module Html2Text
  module Parsers
    class Base
      include Html2Text::Parsers::Concerns::NodeUtils
      attr_reader :args

      def initialize(args = {})
        @args = args
      end
    end
  end
end
