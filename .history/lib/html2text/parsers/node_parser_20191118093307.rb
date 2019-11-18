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

      def node
      end
    end
  end
end
