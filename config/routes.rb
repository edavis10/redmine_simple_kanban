ActionController::Routing::Routes.draw do |map|
  map.resource :simple_kanban, :member => {:take_issue => :put}
end
