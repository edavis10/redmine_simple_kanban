class SimpleKanban
  def self.next_issue
    status_id = next_status_id
    return nil if status_id.nil?
    
    Issue.visible.first(:conditions => {
                          :status_id => status_id,
                          :kanban_blocked => false,
                          :assigned_to_id => nil
                        },
                        :order => 'due_date ASC, expedite DESC')
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
