module RedmineSimpleKanban
  module Hooks
    class ControllerIssuesEditBeforeSaveHook < Redmine::Hook::ViewListener
      # * issue
      # * params
      # * time_entry
      # * journal
      def controller_issues_edit_before_save(context={})
        params = context[:params]
        
        if params && params[:issue] && params[:issue][:kanban_blocked].present?
          context[:issue].kanban_blocked = params[:issue][:kanban_blocked]
        end

        if params && params[:issue] && params[:issue][:expedite].present?
          context[:issue].expedite = params[:issue][:expedite]
        end

        if params && params[:issue] && params[:issue][:skill_list].present?
          old_skill_list = context[:issue].skill_list
          new_skill_list = params[:issue][:skill_list]
          context[:issue].skill_list = new_skill_list
          context[:issue].current_journal.details << JournalDetail.new(:property => 'attr',
                                                                       :prop_key => 'skill_list',
                                                                       :old_value => old_skill_list.to_s,
                                                                       :value => new_skill_list.to_s) unless old_skill_list == new_skill_list || context[:issue].current_journal.blank?
        end
        
        return ''
      end
    end
  end
end
