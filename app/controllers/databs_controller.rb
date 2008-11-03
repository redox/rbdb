class DatabsController < ApplicationController
  # GET /databs
  # GET /databs.xml
  def index
    @databs = Datab.all
    @datab = Datab.new
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @databs }
    end
  end

  # GET /databs/1
  # GET /databs/1.xml
  def show
    @datab = Datab.find params[:id]

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @datab }
    end
  end

  # GET /databs/1/edit
  def edit
    @datab = Datab.find params[:id]
  end

  # POST /databs
  # POST /databs.xml
  def create
    if (Datab.create(params[:datab]) rescue nil)
      flash[:notice] = 'Datab was successfully created.'
    else
      flash[:error] = 'Pas bon'
    end
    redirect_to databs_path
  end

end
