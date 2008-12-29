# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  include SessionSizedList

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery # :secret => 'a3d2d7d49f549afb2b0070bf2d5ae125'

  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  before_filter :authenticate
  before_filter :establish_connection
  before_filter :fill_last_queries
  before_filter :fill_last_tables
  before_filter :fill_system_stats

  protected

  def authenticate
    return true if logged_in?
    session[:return_to] = request.request_uri
    flash[:error] = 'Please give your credentials'
    redirect_to :controller => '/accounts', :action => :login
    return false
  end

  def establish_connection
    ActiveRecord::Base.establish_connection :username => session[:username],
      :password => session[:password],
      :adapter => 'mysql',
      :database => '',
      :host => session[:host],
      :port => session[:port]
    return true
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

  def select_table
    @table = @datab.tables.find((params[:table_id] or params[:id]))
    return true if !@table.nil?
    flash[:notice] = "The table #{params[:table_id] or params[:id]} does not exist"
    redirect_to :controller => '/databs', :action => :index
    return false
  end

  def fill_last_queries
    @sqls = []
    session[:sqls].each do |s|
      @sqls << Sql.new(s)
    end if session[:sqls]
    return true
  end

  MAX_STORED_QUERIES = 5
  def store_sql(sql, datab)
    add_to_session :sqls, {
      :body => sql.body,
      :id => sql.id,
      :num_rows => sql.num_rows,
      :db => datab.name
    }, MAX_STORED_QUERIES
  end
  
  def fill_last_tables
    @last_tables = session[:last_tables] or []
  end
  
  def fill_system_stats
    @load_average = IO.popen("uptime") { |pipe| pipe.read }.split(" ")[-3] rescue 0
    questions = 0
    uptime = 0
    ActiveRecord::Base.connection.execute("SHOW STATUS").each do |r|
      questions = r[1].to_i if r[0] == 'Questions'
      uptime = r[1].to_i if r[0] == 'Uptime'
    end
    @requests_per_second = questions.to_f / uptime rescue 0
    
    ActiveRecord::Base.connection.execute("SHOW VARIABLES").each do |r|
      @server_version = r[1] if r[0] == 'version'
    end
    @server = 'localhost' # FIXME
  end
  
  def logged_in?
    session[:username]
  end
end
