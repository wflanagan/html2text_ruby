# frozen_string_literal: true

module Html2Text
  module Parsers
    # Parses JSONLD on the page and returns methods that match individual
    # items on the page. Also supplies an "Audienti Meta Page (AMP)" that
    #  is a simple representation of the page as HTML
    class Microformats < Base
      include Html2Text::Parsers::Concerns::BaseAccessors

      def call
        raise "needs to be defined"
      end

      # JSONLD tags could be a single tags, or could be an array
      # of tags. There can be 1 or MORE tags listed on page. All of these
      # are valid standards for how JSON+LD is represented on a page.
      #
      # @return [Array] Array of Nokogiri Objects
      def tags
        @tags ||= doc.xpath('//script[@type="application/ld+json"]')
      end

      # Takes the found tags and parses them into hashes by decoding
      # the JSON
      #
      # @return [Array] array of Hashes
      def objects
        @objects ||= begin
          objects = []
          tags.each do |node|
            object = JSON.parse(node.content)
            if object.is_a?(Hash)
              objects << object
            elsif object.is_a?(Array)
              object.each { |part| objects << part }
            end
          end
          objects
        end
      end

      # An Alternative Meta Page (AMP) is an HTML document that can be
      # parsed that is generated exclusively from the Meta information
      # supplied on the page.
      def amp
        @amp ||= begin

        end
      end

      def image_object
        @image_object ||= Html2Text::Microformatters::ImageObject.new(objects: objects, doc: doc).call
      end

      def video_object
        @video_object ||= Html2Text::Microformatters::VideoObject.new(objects: objects, doc: doc).call
      end
    end
  end
end
