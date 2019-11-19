# frozen_string_literal: true

module Html2Text
  module Microformatters
    class Thing < MicroformatBase
      def description
        first_selected('description')
      end

      def media_url
        first_selected('image')
      end

      def url
        first_selected('url')
      end

      # A thing's name is the title
      def title
        first_selected('name')
      end

      def content_type
        'thing'
      end

      def supported_objects
        { 'Thing' => {'@context' => 'schema.org', '@type' => 'Thing'} }
      end
    end
  end
end
