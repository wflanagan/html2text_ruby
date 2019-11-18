# frozen_string_literal: true

module Html2Text
  module Parsers
    # Provides the description meta back from the base supplied
    # #doc
    class Html
      class Descriptions < Base
        include Html2Text::Parsers::Concerns::BaseAccessors
        def call
          description
        end
        # Extracts the description from the page using meta information
        #
        # @return [String] the best (first) description
        def description
          @description ||= descriptions.first
        end

        # Extracts all the potential descriptions from the page, using the
        # description matchers
        def descriptions
          @descriptions ||= doc_matches(description_matchers)
                               .flatten
                               .reject(&:blank?)
                               .uniq
        end

        # Provides a list of extraction methods to pass to Nokogiri to extract
        # potential descritpions from the Nokogiri document
        def description_matchers
          [ ['meta[@name="og:description"]',       lambda { |el| el.attr('content') }],
            ['meta[@name="description"]',          lambda { |el| el.attr('content') }],
            ['meta[@name="twitter:description"]',  lambda { |el| el.attr('content') }],
            ['meta[@name="sailthru.description"]', lambda { |el| el.attr('content') }],
            ['meta[@name="dc:description"]',       lambda { |el| el.attr('content') }],
            ['meta[@name="parsely-description"]',  lambda { |el| el.attr('content') }],
            ['meta[@name="Description"]',          lambda { |el| el.attr('content') }],
            ['meta[@name="DESCRIPTION"]',          lambda { |el| el.attr('content') }],
            'rdf:Description[@name="dc:description"]' ]
        end
      end
    end
  end
end
