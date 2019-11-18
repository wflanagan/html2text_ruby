# frozen_string_literal: true

module Html2Text
  module Parsers
    class Html
      # Extracts the best title of the page based on the
      # query order
      class Title
        include Html2Text::Parsers::Concerns::BaseAccessors

        # The best (first) title of the page based on the query order
        # defined in this class
        #
        # @return [String] Best Title of page
        def call
          title
        end

        # Extracts the title, and then, alternatively, the og:title, from the
        # document
        #
        # @return [String] best title
        def title
          @title ||= title&.first
        end

        # The document result of the matching of the document against the title
        # matchers. Uses blank? because we now require ActiveSupport so this is
        # available
        #
        # @return [Array] array of strings
        def titles
          @titles ||= doc_matches(title_matchers)
                         .flatten
                         .reject(&:blank?)
                         .uniq
        end

        # Title matchers lists the queries that are made, in order, to attempt
        # to find a title on the page.
        #
        # @return [Array] array of matchers
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
