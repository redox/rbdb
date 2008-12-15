class GraphsController < ApplicationController
  before_filter :select_db
  before_filter :select_table  

  def index
    @columns = Graph.select_relevant_columns @table
    @evolution = params[:evolution] == "true"
  end

  def show
    @column = params[:id] or 'created_at'
    @type = ["pie", "line"].include?(params[:type]) ? params[:type] : "pie"
    @title = params.has_key?(:title) ? params[:title] : "#{@table.name}+»+#{@column}"
    @graph = (@column == 'created_at') ? Graph.generate_created_at(@table, (params[:evolution] == "true")) : Graph.generate(@datab, @table, @column)
  end

end
