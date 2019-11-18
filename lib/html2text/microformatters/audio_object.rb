# frozen_string_literal: true

module Html2Text
  module Microformatters
    class AudioObject < MediaObject
      def data
        { comments_count: comments_count }
      end

      def content_type
        'audio'
      end

      def supported_objects
        { 'AudioObject' => {'@context' => 'schema.org', '@type' => 'AudioObject'} }
      end
    end
  end
end
