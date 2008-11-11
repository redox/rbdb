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
    if (Datab.create(params[:datab]) rescue nil)
      flash[:notice] = "Database #{params[:datab][:name]} was successfully created."
    else
      flash[:error] = 'Pas bon'
    end
    redirect_to databs_path
  end

  def destroy
    if (Datab.destroy params[:id] rescue nil)
      flash[:notice] = "Database #{params[:id]} was successfully deleted."
    else
      flash[:error] = 'Pas bon'
    end
    redirect_to databs_path
  end

end
