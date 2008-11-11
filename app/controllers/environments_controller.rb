class EnvironmentsController < ApplicationController

  def index
    @environments = ActiveRecord::Base.connection.execute("SHOW VARIABLES")
  end

end
