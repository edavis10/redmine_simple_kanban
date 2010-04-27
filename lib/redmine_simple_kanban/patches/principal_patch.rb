module RedmineSimpleKanban
  module Patches
    module PrincipalPatch
      def self.included(base)
        base.extend(ClassMethods)

        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable

          acts_as_taggable_on :skills

        end
      end

      module ClassMethods
      end

      module InstanceMethods
      end
    end
  end
end
