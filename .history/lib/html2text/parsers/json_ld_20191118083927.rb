# frozen_string_literal: true

module Html2Text
  module Parsers
    # Parses JSONLD on the page and returns methods that match individual
    # items on the page. Also supplies an "amp" which is a simple

    class JsonLd
      include Html2Text::Parsers::Concerns::NodeUtils
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

      # Extracts the description from the page using meta information
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

      def image_objects
        @image_objects ||= begin

        end
      end

      def reader
        @reader ||= JSON::LD::Reader.new(tags)
      end

      def statements
        reader.each_statement { |statement| puts statement.class }
      rescue => e
        binding.pry
      end
    end
  end
end
