module RedmineSimpleKanban
  module Hooks
    class ViewUsersFormHook < Redmine::Hook::ViewListener
      render_on :view_users_form, :partial => 'users/skills'
    end
  end
end
