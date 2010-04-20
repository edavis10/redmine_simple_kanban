module RedmineSimpleKanban
  module Patches
    module IssuePatch
      def self.included(base)
        base.extend(ClassMethods)

        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable

          named_scope :includes_for_simple_kanban, :include => [:status, :priority, :tracker, :assigned_to]
          named_scope :with_status_id, lambda {|status_id|
            {
              :conditions => { :status_id => status_id.to_i }
            }
          }

          named_scope :order_for_simple_kanban, :order => "#{Issue.table_name}.start_date ASC"
          named_scope :order_for_simple_kanban_next, :order => "#{Issue.table_name}.expedite DESC, #{Issue.table_name}.due_date ASC, #{Issue.table_name}.start_date ASC"

          named_scope :updated_today, lambda {
            {
              :conditions => ["#{Issue.table_name}.updated_on > ?", Date.today.beginning_of_day]
            }
          }
        end
      end

      module ClassMethods
      end

      module InstanceMethods
      end
    end
  end
end
