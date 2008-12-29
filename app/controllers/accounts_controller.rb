class AccountsController < ApplicationController
  
  skip_before_filter :authenticate, :only => [:login, :index]
  skip_before_filter :fill_last_queries
  skip_before_filter :fill_system_stats
  skip_before_filter :establish_connection, :only => :login

  def login
    if request.post?
      if do_login
        redirect_to session[:return_to] || databs_path
       end
    end
  end
  
  def logout
    reset_session
    flash[:error] = 'You were logged out'
    redirect_to :action => 'login'
  end
  
  
  private
  def do_login
    config = YAML.load_file(File.join(Rails.root, 'config', 'database.yml'))[Rails.env]
    host = config['host'] # overwrite user specified
    host = params[:host] if host.blank?
    host = 'localhost' if host.blank?
    port = config['port']
    port = nil if port.blank?
    begin
      ActiveRecord::Base.establish_connection :adapter  => "mysql",
        :host     => host,
        :username => params[:username],
        :password => params[:password],
        :database => '',
        :port     => port
      ActiveRecord::Base.connection.execute "show databases"
    rescue
      flash[:error] = ($!).to_s
      return false
    end
    session[:username] = params[:username]
    session[:password] = params[:password]
    session[:host] = host
    session[:port] = port
    return true
  end
  
end
