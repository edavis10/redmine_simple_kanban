class SimpleKanban
  def self.next_issue(user=User.current)
    status_id = next_status_id
    return nil if status_id.nil?
    # OPTIMIZE: should be able to do this in one query instead of
    # pulling data back
    # Two visibles to make sure the issue is visible to both the
    # current user and the user in question
    issues = Issue.visible.visible(user).all(:conditions => {
                                 :status_id => status_id,
                                 :kanban_blocked => false,
                                 :assigned_to_id => nil
                               },
                               :order => 'due_date ASC, expedite DESC')
    # Match skills, a user must have all of the skills an issue requires
    issues.detect {|issue|
      if issue.skill_list.blank?
        issue
      else
        if issue.skill_list.all? {|skill| user.skill_list.include?(skill)}
          issue
        else
          false
        end
      end
    }
  end

  def self.next_status_id
    if Setting.plugin_redmine_simple_kanban['next_swimlane'].present? &&
        Setting.plugin_redmine_simple_kanban['next_swimlane']['status_id'].present?
      Setting.plugin_redmine_simple_kanban['next_swimlane']['status_id']
    else
      nil
    end
  end
end
