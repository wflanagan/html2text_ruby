module Html2Text
  module Parsers
    class Html < Base
      include Html2Text::Parsers::Concerns::BaseAccessors
      class Title
             # Extracts the title, and then, alternatively, the og:title, from the
      # document
      def title
        @title ||= title&.first
      end

      # The document result of the matching of the document against the title
      # matchers. Uses blank? because we now require ActiveSupport so this is
      # available
      def titles
        @titles ||= doc_matches(title_matchers)
                       .flatten
                       .reject(&:blank?)
                       .uniq
      end

      # Title matchers lists the queries that are made, in order, to attempt
      # to find a title on the page.
      def title_matchers
        [ ['meta[@name="og:title"]',       lambda { |el| el.attr('content') }],
          ['meta[@name="twitter:title"]',  lambda { |el| el.attr('content') }],
          ['meta[@name="dc:title"]',       lambda { |el| el.attr('content') }],
          ['meta[@name="parsely-title"]',  lambda { |el| el.attr('content') }],
          ['meta[@name="sailthru.title"]', lambda { |el| el.attr('content') }],
          ['meta[@name="title"]',          lambda { |el| el.attr('content') }] ]
      end
      end
    end
  end
end
