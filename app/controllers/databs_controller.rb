class DatabsController < ApplicationController

  def index
    @databs = Datab.all
    @datab = Datab.new
  end

  def show
    @datab = Datab.find params[:id]
  end

  def edit
    @datab = Datab.find params[:id]
  end

  def create
    Datab.create! params[:datab]
    flash[:notice] = "Database #{params[:datab][:name]} was successfully created."
  rescue StandardError => e
    flash[:notice] = e.to_s
  ensure
    redirect_to databs_path
  end

  def destroy
    Datab.destroy! params[:id]
    flash[:notice] = "Database #{params[:id]} was successfully deleted."
  rescue StandardError => e
    flash[:notice] = e.to_s
  ensure
    redirect_to databs_path
  end

end
