# frozen_string_literal: true

module Html2Text
  module Parsers
    class Html
      # Parses an an image node, returning the supplied output
      # including the text
      class ImagheNode < NodeParser
        def call
          image_text
        end

        # Parses the supplied node as arguments, and returns
        # a text representation of the image
        #
        # @return [String] text replacement for an image
        def image_text
          if node.attribute('title')
            '[' + node.attribute('title').to_s + ']'
          elsif node.attribute('alt')
            '[' + node.attribute('alt').to_s + ']'
          else
            ''
          end
        end
      end
    end
  end
end
