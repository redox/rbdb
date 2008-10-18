# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  before_filter :authenticate
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'a3d2d7d49f549afb2b0070bf2d5ae125'

  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  before_filter :fill_last_queries, :except => [:login]
  around_filter :rescue_connexion

  protected

  def authenticate
    unless session[:authenticated]
      session[:return_to] = request.request_uri
      flash[:error] = 'please give your credentials'
      redirect_to :controller => '/accounts', :action => :login
      return false
    end
  end

  def rescue_connexion 
    yield
  rescue ActiveRecord::ConnectionNotEstablished
    flash[:error] = 'The connection with the datase server was lost'
    session[:authenticated] = nil
    redirect_to :controller => 'accounts', :action => 'login'
    return false
  end

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
    session[:authenticated] = true
    session[:username] = params[:username]
    return true
  end

  def select_table
    @table = @datab.tables.find params[:table_id]
  end

  def fill_last_queries
    @sqls = []
    session[:sqls].each do |s|
      @sqls << Sql.new(s)
    end if session[:sqls]
    return true
  end

  MAX_STORED_QUERIES = 5
  def store_sql(sql)
    session[:sqls] ||= []
    session[:sqls].shift if session[:sqls].size > MAX_STORED_QUERIES
    session[:sqls] << {:body => @sql.body, :id => @sql.id}
  end

  def update_sql(sql)
    s = session[:sqls].detect { |s| s[:id].to_i == sql.id }
    s[:body] = sql.body
  end

end
