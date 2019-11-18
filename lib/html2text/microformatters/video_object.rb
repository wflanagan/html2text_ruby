# frozen_string_literal: true

module Html2Text
  module Microformatters
    class VideoObject < MediaObject
      def data
        { comments_count: comments_count,
          watches_count: watches_count }
      end

      def description
        first_selected('description')
      end

      def comments_count
        first_selected('commentCount')
      end

      def watches_count
        first_selected_if(["interactionStatistic", "interactionType", "@type"], "WatchAction", "interactionStatistic", "userInteractionCount")
      end

      def media_url
        @media_url ||= first_selected("thumbnailUrl") || get_meta("og:image")
      end

      def url
        first_selected('mainEntityofPage', '@id') || get_meta('og:url')
      end

      def content_type
        'video'
      end

      def supported_objects
        { 'VideoObject' => {'@context' => 'schema.org', '@type' => 'VideoObject'} }
      end
    end
  end
end
