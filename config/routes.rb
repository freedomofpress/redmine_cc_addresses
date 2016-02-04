RedmineApp::Application.routes.draw do
  match 'issues/:issue_id/cc_addresses/:action/:id', :to => 'cc_addresses#new_issue_add_cc', :via => [:get, :post]
end
