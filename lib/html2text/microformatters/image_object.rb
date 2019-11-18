# frozen_string_literal: true

module Html2Text
  module Microformatters
    class ImageObject < MediaObject
      def data
        { comments_count: comments_count,
          likes_count: likes_count }
      end

      def replaces_page?
        first_selected('representativeOfPage')&.to_s&.downcase&.include?('true')
      end

      def likes_count
        first_selected_if(["interactionStatistic", "interactionType", "@type"], "LikeAction", "interactionStatistic", "userInteractionCount")
      end

      def content_type
        'image'
      end

      def supported_objects
        { 'ImageObject' => {'@context' => 'schema.org', '@type' => 'ImageObject'} }
      end
    end
  end
end
