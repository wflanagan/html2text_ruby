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
      def json_ld_tags
        @json_ld_tags ||= doc.xpath('//script[@type="application/ld+json"]')
      end

      # Takes the found json_ld_tags and parses them into hashes
      def json_ld_objects
      end
    end
  end
end
