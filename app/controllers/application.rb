# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'a3d2d7d49f549afb2b0070bf2d5ae125'

  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password


  protected
  def select_db
    if params[:datab_id].blank?
      flash[:notice] = 'You must select a database!'
      redirect_to :controller => '/databs', :action => :index
      return false
    end
    @datab = Datab.find(params[:datab_id])
    Datab.execute "use #{@datab.name}"
  end

  def do_login
    begin
      ActiveRecord::Base.establish_connection(
      :adapter  => "mysql",
      :host     => params[:host] || "localhost",
      :username => params[:username],
      :password => params[:password],
      :database => ''
      )
      ActiveRecord::Base.connection.execute "show databases"
    rescue Mysql::Error
      flash[:error] = ($!).to_s
      return false
    end
    return true
  end

  def select_table
    @table = @datab.tables.find params[:table_id]
  end

end
