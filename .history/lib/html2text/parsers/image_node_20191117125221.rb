module Html2Text
  module Parsers
    # Parses an a link node, returning the supplied output including the text
    class ImageNode
      include Html2Text::Parsers::Concerns::NodeUtils
      attr_reader :args

      def initialize(args = {})
        @args = args
      end

      def node
        @node ||= args.dig(:node)
      end

      def input
        @input ||= args.dig(:input)
      end

      def call
        wrap_link(node, input)
      end

      def wrap_link(node, output)
        href = node.attribute('href')
        name = node.attribute('name')

        output = output.strip
        # output = "#{output} " if Html2Text::Utils.ends_with_punctuation?(output)

        # remove double [[ ]]s from linking images
        if output[0] == '[' && output[-1] == ']'
          output = output[1, output.length - 2]

          # for linking images, the title of the <a> overrides the title of the <img>
          if node.attribute('title')
            output = node.attribute('title').to_s
          end
        end

        # if there is no link text, but a title attr
        if output.empty? && node.attribute('title')
          output = node.attribute('title').to_s
        end

        if href.nil?
          output = "[#{output}]" if !name.nil?
        else
          href = href.to_s
          if href != output && href != "mailto:#{output}" && href != "http://#{output}" && href != "https://#{output}"
            if output.empty?
              output = href
            else
              output = "[#{output}](#{href})"
            end
          end
        end

        case next_node_name(node)
          when 'h1', 'h2', 'h3', 'h4', 'h5', 'h6'
            output += "\n" if %w[h1 h2 h3 h4 h5 h6].include?(next_node_name(node))
        end

        output
      end
    end
  end
end