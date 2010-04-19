class AddKanbanBockedToIssues < ActiveRecord::Migration
  def self.up
    add_column :issues, :kanban_blocked, :boolean, :default => false
  end

  def self.down
    remove_column :issues, :kanban_blocked
  end
end
