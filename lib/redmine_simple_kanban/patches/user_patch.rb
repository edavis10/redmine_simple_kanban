module RedmineSimpleKanban
  module Patches
    module UserPatch
      def self.included(base)
        base.extend(ClassMethods)

        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable

          # STI is throwing acts_as_taggable_on for a loop and causing
          # the tag_types attribute to be nil (even though it's inheritable)
          def self.tag_types
            [:skills]
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
