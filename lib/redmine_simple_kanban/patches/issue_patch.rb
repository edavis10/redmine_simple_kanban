module RedmineSimpleKanban
  module Patches
    module IssuePatch
      def self.included(base)
        base.extend(ClassMethods)

        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable

          acts_as_taggable_on :skills
          
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

          named_scope :assigned_to, lambda {|assigned_to|
            id = (assigned_to.is_a?(Integer) || assigned_to.is_a?(String)) ? assigned_to : assigned_to.id
            {
              :conditions => ["#{Issue.table_name}.assigned_to_id = :id OR #{Issue.table_name}.assigned_to_id IS NULL", {:id => id}]
            }
          }

          def self.for_simple_kanban_swimlane(status_id_for_swimlane)
            visible.order_for_simple_kanban.includes_for_simple_kanban.with_status_id(status_id_for_swimlane)
          end
        end
      end

      module ClassMethods
      end

      module InstanceMethods
      end
    end
  end
end
