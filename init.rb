require 'redmine'

Redmine::Plugin.register :redmine_simple_kanban do
  name 'Redmine Simple Kanban plugin'
  author 'Eric Davis'
  description 'Simple implementation of a Kanban Board for use with Redmine to track tasks.'
  url 'https://projects.littlestreamsoftware.com/projects/simple-kanban'
  author_url 'http://www.littlestreamsoftware.com'

  version '0.1.0'

  requires_redmine :version_or_higher => '0.9.0'
end
require 'redmine_simple_kanban/hooks/view_issues_form_details_bottom_hook'
require 'redmine_simple_kanban/hooks/controller_issues_edit_before_save_hook'
require 'redmine_simple_kanban/hooks/view_issues_show_details_bottom_hook'
