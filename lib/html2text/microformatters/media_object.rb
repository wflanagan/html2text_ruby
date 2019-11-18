#frozen_string_literal: true

module Html2Text
  module Microformatters
    # Schema.org MediaObject formatter
    class MediaObject < MicroformatBase
      def title
        first_selected('headline') || first_selected('name')
      end

      def text
        first_selected('caption')
      end

      def data
        { comments_count: comments_count,
          likes_count: likes_count }
      end

      # Links to the actual content file
      def content_url
        @content_url ||= first_selected("contentUrl")
      end

      def replaces_page?
        first_selected('representativeOfPage')&.to_s&.downcase&.include?('true')
      end

      def description
        first_selected('description') || first_selected("abstract")
      end

      def comments_count
        first_selected('commentCount')
      end

      def published_at
        first_selected('uploadDate')
      end

      def media_url
        @media_url ||= get_meta("og:image")
      end

      def url
        first_selected('mainEntityofPage', '@id') || get_meta('og:url')
      end

      def content_type
        'media'
      end

      def comments
        @comments ||= begin
          comments = []
          Array(first_selected('comment')).each do |ind_comment|
            comment_text = ind_comment.dig("text")
            next unless comment_text.present?

            author_name = ind_comment.dig("author", "name") || ind_comment.dig("author", "alternateName")
            author_profile_url = ind_comment.dig("author", "mainEntityofPage", "@id")
            next unless author_profile_url.present?

            comments << {text: comment_text, author_name: author_name, author_profile_url: author_profile_url }
          end
          comments
        end
      end

      def additional_profiles
        @additional_profiles ||= comments.map { |comment| comment[:author_profile_url] }
      end

      def author_name
        first_selected('author', 'name') || first_selected('author', 'alternateName')
      end

      def author_profile_url
        first_selected('author', 'mainEntityofPage', '@id')
      end

      def supported_objects
        raise 'must be defined in your child class'
      end
    end
  end
end
