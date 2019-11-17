# frozen_string_literal: true

module Html2Text
  module Parsers
    # Parses HTML and returns formatted raw text
    # for the supplied HTML
    class Html
      include Html2Text::Parsers::Concerns::NodeUtils
      attr_reader :args

      def initialize(args = {})
        @args = args
      end

      def call
        text
      end

      def text
        @text ||= begin
          output = iterate_over(doc)
          output = Html2Text::Utils.remove_leading_and_trailing_whitespace(output)
          output = Html2Text::Utils.remove_unnecessary_empty_lines(output)
          output.strip
        end
      end

      # The primary code that iterates over the node, producing the text
      # that we will return.
      def iterate_over(node)
        return "\n" if node_kind?(node, 'br') && next_node_is_text?(node)
        return Html2Text::Utils.trimmed_whitespace(node.text) if node.text?
        return '' if non_printable_node?(node)

        return "\n#{Html2Text::Utils::DO_NOT_TOUCH_WHITESPACE}#{node.text}#{Html2Text::Utils::DO_NOT_TOUCH_WHITESPACE}" if node_kind?('pre')

        output = []
        output << prefix_whitespace(node)
        output += node.children.map { |child| iterate_over(child) }
        output << suffix_whitespace(node)
        output = output.compact.join || ''

        if node.name.downcase == 'a'
          output = Html2Text::Parsers::ImageNode.new(node: node, input: output).call
        elsif node.name.downcase == 'img'
          output = image_text(node)
        end

        output
      end

      def prefix_whitespace(node)
        if node.name.downcase == 'div'
          return '' if node.parent.name == 'div' && node_and_parent_same_text?(node)

          "\n" # if it's not the above, then we return this
        else
          Html2Text::Utils.prefix_whitespace_options[node.name.downcase]
        end
      end

      def suffix_whitespace(node)
        node_name = node.name.downcase
        return "\n" if node_name == "br" && next_node_not_div_or_nil?(node)
        return "\n" if node_name == "div" && (next_node_is_text?(node) || next_node_not_div_or_nil?(node))

        Html2Text::Utils.suffix_whitespace_options[node_name]
      end

      def image_text(node)
        if node.attribute('title')
          '[' + node.attribute('title').to_s + ']'
        elsif node.attribute('alt')
          '[' + node.attribute('alt').to_s + ']'
        else
          ''
        end
      end

      def html
        @html ||= args.dig(:html).to_s
      end

      def formatted_html
        @formatted_html ||= Html2Text::HtmlFormatter.new(html: html).call
      end

      # Produces a Nokogiri object from the formatted text
      def doc
        @doc ||= Nokogiri::HTML.parse(formatted_html, nil, 'UTF-8')
      end
    end
  end
end
