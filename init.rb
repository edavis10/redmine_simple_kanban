require 'redmine'

Redmine::Plugin.register :redmine_simple_kanban do
  name 'Redmine Simple Kanban plugin'
  author 'Eric Davis'
  description 'Simple implementation of a Kanban Board for use with Redmine to track tasks.'
  url 'https://projects.littlestreamsoftware.com/projects/simple-kanban'
  author_url 'http://www.littlestreamsoftware.com'

  version '0.1.0'

  requires_redmine :version_or_higher => '0.9.0'

  settings(:partial => 'settings/simple_kanban_settings',
           :default => {
             'next_swimlane' => { 'status_id' => nil},
             'in_progress_swimlane' => { 'status_id' => nil},
             'acceptance_swimlane' => { 'status_id' => nil},
             'done_swimlane' => { 'status_id' => nil}
           })

  menu(:top_menu,
       :simple_kanban,
       {:controller => 'simple_kanbans', :action => 'show'},
       :caption => :simple_kanban_title)

end
require 'redmine_simple_kanban/hooks/view_issues_form_details_bottom_hook'
require 'redmine_simple_kanban/hooks/controller_issues_edit_before_save_hook'
require 'redmine_simple_kanban/hooks/view_issues_show_details_bottom_hook'
require 'dispatcher'
Dispatcher.to_prepare :redmine_simple_kanban do

  require_dependency 'issue'
  Issue.send(:include, RedmineSimpleKanban::Patches::IssuePatch)
end