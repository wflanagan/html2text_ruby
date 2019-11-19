# frozen_string_literal: true

module Html2Text
  module Parsers
    # Parses HTML and returns formatted raw text
    # for the supplied HTML
    class Html < Base
      attr_reader :node_count

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
      #
      # Note that this method calls itself, so be aware of this.
      #
      # @return [String] text extracted from the HTML node.
      def iterate_over(node)
        increment_node_count
        return "" if node_count > node_limit
        return "\n" if node_kind?(node, 'br') && next_node_is_text?(node)
        return Html2Text::Utils.trimmed_whitespace(node.text) if node.text?
        return '' if non_printable_node?(node)
        return "\n#{Html2Text::Utils::DO_NOT_TOUCH_WHITESPACE}#{node.text}#{Html2Text::Utils::DO_NOT_TOUCH_WHITESPACE}" if node_kind?(node, 'pre')

        output = []
        output << prefix_whitespace(node)
        output += node.children.map { |child| iterate_over(child) }
        output << suffix_whitespace(node)
        output = output.compact.join || ''

        if node_kind?(node, 'a')
          output = Html2Text::Parsers::Html::ANode.new(node: node, input: output, format_links: include_links?).call
        elsif node_kind?(node, 'button')
          output = node.text
        elsif node_kind?(node, 'img')
          output = Html2Text::Parsers::Html::ImageNode.new(node: node).call
        end

        output
      end

      # Adds whitepace before the node in passed as arguments
      # base on configured parameters
      #
      # @return [String] string whitespace
      def prefix_whitespace(node)
        if node_kind?(node, 'div')
          return '' if node_kind?(node.parent, 'div') && node_and_parent_same_text?(node)

          "\n" # if it's not the above, then we return this
        else
          str = Html2Text::Utils.prefix_whitespace_options[node.name.downcase]
          str += Html2Text::Utils::HEADER_TAG if node_header_tag?(node)
          str
        end
      end

      # Adds trailing whitepace before the node in passed as arguments
      # based on configured parameters
      #
      # @return [String] string whitespace
      def suffix_whitespace(node)
        node_name = node.name.downcase
        return "\n" if node_name == "br" && next_node_not_div_or_nil?(node)
        return "\n" if node_name == "div" && (next_node_is_text?(node) || next_node_not_div_or_nil?(node))

        str = Html2Text::Utils.suffix_whitespace_options[node_name]
        str += Html2Text::Utils::HEADER_TAG if node_header_tag?(node)
        str
      end

      # The supplied HTML document
      #
      # @return [String] the html document or ""
      def html
        @html ||= args.dig(:html).to_s
      end

      # Calls the HTMLformatter to remove bad things
      # from the HTML to make our ability to parse it easier
      # and less error prone.
      #
      # @return [String] the html document or ""
      def formatted_html
        @formatted_html ||= Html2Text::Formatters::Html.new(html: html).call
      end

      # Produces a Nokogiri object from the formatted text
      def doc
        @doc ||= Nokogiri::HTML.parse(formatted_html, nil, 'UTF-8')
      end

      # Container for all the microformat parsing we do in the system
      # to produce alternative versions of the text, in the case of HTML5
      # and React-based pages
      def microformats
        @microformats ||= Html2Text::Parsers::Microformats.new(doc: doc, html: formatted_html, url: url)
      end

      # Container for the sentence parser
      def sentences
        @sentences ||= Html2Text::Parsers::Sentences.new(text: text, tagged_headings: tag_headers?)
      end

      # If there is a request to tag headers, then the sytsem will add these
      # tags around the headers. This is to preserve them in later processing
      #
      # @return [Boolean] true or false
      def tag_headers?
        @tag_headers ||= args.dig(:tag_headings) || false
      end

      # If the node is a header, and the tag_headers is true, then
      # this will be true
      #
      # @return [Boolean] true or false
      def node_header_tag?(node)
        tag_headers? && node_header?(node)
      end

      # If there is a request to include link formatting [text](https:// format),
      # then the sytsem will add these tags around the a links.  It will just
      # return the inner text if not.
      #
      # @return [Boolean] true or false
      def include_links?
        @include_links ||= args.dig(:include_links) || true
      end

      # Sets a maximum node limit for parsing HTML pages. Once we hit this limit
      # we stop and return
      def node_limit
        @node_limit ||= args.dig(:node_limit) || 10_000
      end

      # Adds 1 to the node_count
      def increment_node_count
        @node_count = 0 if @node_count.nil?
        @node_count += 1
      end
    end
  end
end
