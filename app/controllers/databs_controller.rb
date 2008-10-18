class DatabsController < ApplicationController
  # GET /databs
  # GET /databs.xml
  def index
    @databs = Datab.all

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

  # GET /databs/new
  # GET /databs/new.xml
  def new
    @datab = Datab.new

    respond_to do |format|
      format.html # new.html.erb
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
    @datab = Datab.new(params[:datab])

    respond_to do |format|
      if @datab.save
        flash[:notice] = 'Datab was successfully created.'
        format.html { redirect_to(@datab) }
        format.xml  { render :xml => @datab, :status => :created, :location => @datab }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @datab.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /databs/1
  # PUT /databs/1.xml
  def update
    @datab = Datab.find(params[:id])

    respond_to do |format|
      if @datab.update_attributes(params[:datab])
        flash[:notice] = 'Datab was successfully updated.'
        format.html { redirect_to(@datab) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @datab.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /databs/1
  # DELETE /databs/1.xml
  def destroy
    @datab = Datab.find(params[:id])
    @datab.destroy

    respond_to do |format|
      format.html { redirect_to(databs_url) }
      format.xml  { head :ok }
    end
  end

end
