class AccountsController < ApplicationController
  
  skip_before_filter :authenticate, :only => [:login, :index]
  skip_before_filter :fill_last_queries
  skip_before_filter :fill_system_stats
  skip_before_filter :establish_connection, :only => :login
  
  def index
  end
  
  def login
    if request.post?
      if do_login
        redirect_to session[:return_to] || '/databs'
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
    begin
      ActiveRecord::Base.establish_connection(
      :adapter  => "mysql",
      :host     => params[:host] || "localhost",
      :username => params[:username],
      :password => params[:password],
      :database => ''
      )
      ActiveRecord::Base.connection.execute "show databases"
    rescue
      flash[:error] = ($!).to_s
      return false
    end
    session[:authenticated] = true
    session[:username] = params[:username]
    session[:password] = params[:password]
    return true
  end
  
end
