# frozen_string_literal: true

module Html2Text
  module Parsers
    class JsonLd
      attr_reader :args

      def initialize(args = {})
        @args = args
      end

      # This parser requires a Nokogiri Document to be passed to it
      # This methods sets that object. Without this, the system will
      # fail
      #
      # @return [Object] Nokogiri object
      def doc
        @doc ||= args.dig(:doc)
      end

      # JSONLD tags could be a single tags, or could be an array
      # of tags. There can be 1 or MORE tags listed on page. All of these
      # are valid standards for how JSON+LD is represented on a page.
      #
      # @return [Array] Array of Nokogiri Objects
      def tags
        @tags ||= doc.xpath('//script[@type="application/ld+json"]')
      end

      # Takes the found json_ld_tags and parses them into hashes by decoding
      # the JSON
      def objects
        @objects ||= begin
          json_ld_objects = []
          json_ld_tags.each do |node|
            object = JSON.parse(node.content)
            if object.is_a?(Hash)
              json_ld_objects << object
            elsif object.is_a?(Array)
              object.each { |part| json_ld_objects << part }
            end
          end
          json_ld_objects
        end
      end

      # An Alternative Meta Page (AMP) is an HTML document that can be
      # parsed that is generated exclusively from the Meta information
      # supplied on the page.
      def amp
        @amp ||= begin

        end
      end

      # Extracts the title, and then, alternatively, the og:title, from the
      # document
      def title
      end

      def title_matches
      end

      # Title matchers lists the queries that are made, in order, to attempt
      # to find a title on the page.
      def title_matchers
        [
          ['meta[@name="og:title"]',       lambda { |el| el.attr('content') }],
          ['meta[@name="twitter:title"]',  lambda { |el| el.attr('content') }],
          ['meta[@name="dc:title"]',       lambda { |el| el.attr('content') }],
          ['meta[@name="parsely-title"]',  lambda { |el| el.attr('content') }],
          ['meta[@name="sailthru.title"]', lambda { |el| el.attr('content') }],
          ['meta[@name="title"]',          lambda { |el| el.attr('content') }]
        ]
      end
    end
  end
end
