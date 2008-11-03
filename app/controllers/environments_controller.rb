class EnvironmentsController < ApplicationController
  # GET /environments
  # GET /environments.xml
  def index
    @environments = ActiveRecord::Base.connection.execute("SHOW VARIABLES")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @environments }
    end
  end

end
