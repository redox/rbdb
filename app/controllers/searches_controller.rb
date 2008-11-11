class SearchesController < ApplicationController
  before_filter :select_db
  before_filter :select_table
  before_filter :remove_blank_fields, :only => [:create, :update]
  
  def show
    @conditions = session[:searches][params[:id].to_i][:conditions]

    if params.has_key? :per_page
      session[:per_page] = params[:per_page].to_i
    end
    session[:per_page] ||= 30

    @rows = @table.ar_class.paginate(:conditions => @conditions, :page => params[:page],
     :per_page => session[:per_page])
  end

  def new
    @search = Search.new(@table)
    @row = @search.row
  end

  def edit
    s = session[:searches][params[:id].to_i]
    @search = Search.new(@table, s[:attributes], s[:modifiers])
    @row = @search.row
  end

  def create
    @search = Search.new(@table, params[:search], params[:modifiers])

    if @search.save
      session[:searches] ||= {}
      session[:searches][@search.id] = {
        :conditions => @search.conditions,
        :attributes => @search.row.attributes,
        :modifiers => @search.modifiers
      }
      flash[:notice] = 'Search was successfully created.'
      redirect_to datab_table_search_path(@datab, @table, @search)
    else
      render :action => "new"
    end
  end

  def update
    @search = Search.find(params[:id])

    if @search.update_attributes(params[:search])
      flash[:notice] = 'Search was successfully updated.'
      redirect_to(@search)
    else
      render :action => "edit"
    end
  end
  
  private
  def remove_blank_fields
    params[:search].each do |k,v|
      next if !v.blank?
      params[:search].delete k
    end
  end
end
