class SimpleKanban
  def self.next_issue
    status_id = next_status_id
    return nil if status_id.nil?
    # OPTIMIZE: should be able to do this in one query instead of
    # pulling data back
    issues = Issue.visible.all(:conditions => {
                                 :status_id => status_id,
                                 :kanban_blocked => false,
                                 :assigned_to_id => nil
                               },
                               :order => 'due_date ASC, expedite DESC')
    # Match skills, a user must have all of the skills an issue requires
    issues.select {|issue|
      if issue.skill_list.blank?
        issue
      else
        if issue.skill_list.all? {|skill| User.current.skill_list.include?(skill)}
          issue
        else
          false
        end
      end
    }.first
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
