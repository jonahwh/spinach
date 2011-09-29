module Spinach
  # Spinach DSL aims to provide an easy way to define steps and other domain
  # specific actions into your feature classes
  #
  module DSL

    def self.included(base)
      base.class_eval do
        include InstanceMethods
        extend ClassMethods
      end
    end

    module ClassMethods

      # Defines an action to perform given a particular step literal.
      #
      # @param [String] step name
      #   The step literal
      # @param [Proc] block
      #   action to perform in that step
      #
      # @example
      #   class MyFeature << Spinach::Feature
      #     When "I go to the toilet" do
      #       @sittin_on_the_toilet.must_equal true
      #     end
      #   end
      #
      %w{When Given Then And But}.each do |connector|
        define_method connector do |string, &block|
          define_method("#{connector} #{string}", &block)
        end
      end

      # Defines this feature's name
      #
      # @example
      #   class MyFeature < Spinach::Feature
      #     feature "Satisfy needs"
      #   end
      #
      def feature(name)
        @feature_name = name
      end

      # @return [String] this feature's name
      #
      attr_reader :feature_name
    end

    module InstanceMethods

      # Execute a given step.
      #
      # @param [String] keyword
      #   the connector keyword. It usually is "Given", "Then", "When", "And"
      #   or "But"
      #
      # @param [String] step
      #   the step to execute
      #
      def execute_step(keyword, step)
        method = "#{keyword} #{step}"
        if self.respond_to?(method)
          self.send(method)
        else
          raise Spinach::StepNotDefinedException.new
        end
      end

    end
  end
end
