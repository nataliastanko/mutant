# frozen_string_literal: true

module Mutant
  module Meta
    class Example
      include Adamantium

      include Anima.new(
        :expected,
        :location,
        :lvars,
        :node,
        :original_source,
        :types
      )

      class Expected
        include Anima.new(:original_source, :node)
      end

      # Verification instance for example
      #
      # @return [Verification]
      def verification
        Verification.new(self, generated)
      end
      memoize :verification

      # Example identification
      #
      # @return [String]
      def identification
        location.to_s
      end

      # Context of mutation
      #
      # @return [Context]
      def context
        Context.new(
          Object,
          location.path
        )
      end

      # Original source as generated by unparser
      #
      # @return [String]
      def original_source_generated
        Unparser.unparse(node)
      end
      memoize :original_source_generated

      # Generated mutations on example source
      #
      # @return [Enumerable<Mutant::Mutation>]
      def generated
        Mutator.mutate(node).map do |node|
          Mutation::Evil.new(self, node)
        end
      end
      memoize :generated

    end # Example
  end # Meta
end # Mutant
