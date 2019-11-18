# frozen_string_literal: true

module Html2Text
  module Parsers
    # Base provides the mixins and accessors that are
    # common to all the parsers in the system. It also
    # sets up the node accessors.
    class NodeParser
      include Html2Text::Parsers::Concerns::NodeUtils
      attr_reader :args

      class << self
        def call(*args)
          new(*args).call
        end
      end

      def initialize(args = {})
        @args = args
      end

      # The node we are parsing
      #
      # @return [Object] a Nokogiri Node
      def node
        @node ||= args.dig(:node)
      end

      # The input text that are we
      # either adding to, or returning on
      # no action
      #
      # @return [String] string of text
      def input
        @input ||= args.dig(:input)
      end

      # If the parser needs additional
      # options, we pass them as the third
      # argument. This will let us access
      # them.
      #
      # @return [Hash] hash of options
      def options
        @options ||= args.dig(:opts) || args.dig(:options) {}
      end

      def call
        raise 'must be defined in your child class'
      end
    end
  end
end
