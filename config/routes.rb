ActionController::Routing::Routes.draw do |map|
  map.resources :settings

  map.resources :environments

  map.resources :databs, :as => 'databases' do |datab|
    datab.resources :tables do |table|
      table.resources :rows
      table.resources :searches
      table.resources :graphs
    end
    datab.relations_graph '/relations/:table_id/graph.:format', :controller => 'relations',
      :action => 'graph'
    datab.resources :relations
    datab.resources :sqls    
  end

 
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  map.root :controller => 'databs'
end
