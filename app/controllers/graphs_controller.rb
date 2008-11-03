class GraphsController < ApplicationController
  before_filter :select_db
  before_filter :select_table  

  # GET /graphs
  # GET /graphs.xml
  def index
    @columns = Graph.select_relevant_columns @table
    @evolution = params[:evolution] == "true"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @graphs }
    end
  end

  # GET /graphs/1
  # GET /graphs/1.xml
  def show
    @column = params[:id] or 'created_at'
    @type = ["pie", "line"].include?(params[:type]) ? params[:type] : "pie"
    @title = params.has_key?(:title) ? params[:title] : "#{@table.name}+»+#{@column}"
    @graph = (@column == 'created_at') ? Graph.generate_created_at(@table, (params[:evolution] == "true")) : Graph.generate(@table, @column)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @graph }
    end
  end

end
