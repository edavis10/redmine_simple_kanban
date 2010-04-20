class AddExpediteToIssues < ActiveRecord::Migration
  def self.up
    add_column :issues, :expedite, :boolean, :default => false
  end

  def self.down
    remove_column :issues, :expedite
  end
end
