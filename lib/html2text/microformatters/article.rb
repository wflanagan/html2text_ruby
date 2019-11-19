# frozen_string_literal: true

module Html2Text
  module Microformatters
    class Article < MicroformatBase
      def data
        { comments_count: comments_count,
          tweets_count: tweets_count }
      end

      def comments_count
        first_selected("interactionCount", "UserComments")
      end

      def tweets_count
        first_selected("interactionCount", "UserTweets")
      end

      def replaces_page?
        first_selected('representativeOfPage')&.to_s&.downcase&.include?('true')
      end

      def content_type
        'page'
      end

      def supported_objects
        { 'Article' => {'@context' => 'schema.org', '@type' => 'Article'} }
      end
    end
  end
end
