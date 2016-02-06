Redmine::Plugin.register :redmine_cc_addresses do
  name 'Issue CC Addresses'
  author 'Nick Peelman'
  author_url 'http://peelman.us'
  url 'https://github.com/peelman/redmine_cc_addresses'
  description 'Allows CC Addresses to be attached to an issue'
  version '0.2.0'

  project_module :cc_addresses do |map|
    map.permission :view_cc_addresses, { }
    map.permission :add_cc_addresses, { :cc_addresses => :create }
    map.permission :delete_cc_addresses, { :cc_addresses => :destroy }
  end
end

require_dependency 'issue_patch'
require_dependency 'mailer_patch'

ActionDispatch::Callbacks.to_prepare do
  require_dependency 'cc_addresses_issue_show_hook'
  require_dependency 'issue'
  unless Issue.included_modules.include? IssuePatch
    Issue.send(:include, IssuePatch)
  end
  require_dependency 'mailer'
  unless Mailer.included_modules.include? MailerPatch
    Mailer.send(:include, MailerPatch)
  end
end
