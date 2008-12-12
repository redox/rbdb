class AccountsController < ApplicationController
  
  skip_before_filter :authenticate, :only => [:login, :index]
  skip_before_filter :fill_last_queries
  skip_before_filter :fill_system_stats
  skip_before_filter :establish_connection, :only => :login

  def login
    if request.post?
      if do_login(params[:username], params[:password])
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
  def do_login(username, password)
    begin
      ActiveRecord::Base.establish_connection :adapter  => "mysql",
        :host     => params[:host] || "localhost",
        :username => username,
        :password => password,
        :database => ''
      ActiveRecord::Base.connection.execute "show databases"
    rescue
      flash[:error] = ($!).to_s
      return false
    end
    session[:username] = username
    session[:password] = password
    return true
  end
  
end
