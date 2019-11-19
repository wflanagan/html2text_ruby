# frozen_string_literal: true

module Html2Text
  module Microformatters
    class CreativeWork < Thing
      def data
        {content_rating: content_rating }
      end

      def content_type
        'page'
      end

      def content_rating
        first_selected('contentRating')
      end

      def supported_objects
        { 'CreativeWork' => {'@context' => 'schema.org', '@type' => 'CreativeWork'} }
      end
    end
  end
end
