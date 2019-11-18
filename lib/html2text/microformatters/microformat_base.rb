# frozen_string_literal: true

module Html2Text
  module Microformatters
    # Provides the base accessors that all Microformatters
    # will interit from
    class MicroformatBase
      attr_reader :args

      def initialize(args = {})
        @args = args
      end

      # By defualt, the microformatter returns the data from
      # the formatted method
      #
      # @return [Hash] hash of formatted data
      def call
        before_parse_actions
        after_parse_actions(formatted)
      end

      # Objects are expected to be passed into this. These
      # are expected to be an array of Hashes, with STRINGIFIED
      # key => value pairs (the format by default from parsing)
      # a JSON string.
      #
      # @return [Array] Array of Stringified Hashes
      def objects
        @objects ||= args.dig(:objects)
      end

      # Iterates over the objects and selects the ones
      # that we support with the child microformat parser
      def selected_objects
        @selected_objects ||= begin
          selected_objects = []
          objects.each do |hsh|
            supported_objects.each do |key, config|
              if config.keys.all? { |key| hsh[key].to_s.downcase.include?(config[key].to_s.downcase) }
                selected_objects << hsh.merge('format' => key)
              end
            end
          end
          selected_objects
        end
      end

      # The formatted response that converts all different types of
      # stuff to our common format for microformats. The idea of this is to
      # basically emulate what we extract from a page using our Blackbook
      # parser. So Blackbook can call the microformats, and set its
      # values.
      def formatted
        formatted = {
          additional_profiles: additional_profiles,
          author: {
            image_url: author_image_url,
            name: author_name,
            profile_url: author_profile_url
          },
          comments: comments,
          content_type: content_type,
          data: data,
          description: description,
          media_url: media_url,
          published_at: published_at,
          replaces_page: replaces_page?,
          text: text,
          title: title,
          url: url
        }
        formatted[:published_at] = Chronic.parse(formatted[:published_at]) if formatted[:published_at].present?
        formatted
      end

      def additional_profiles; []; end
      def author_image_url; end
      def author_name; end
      def author_profile_url; end
      def comments; []; end
      def content_type; end
      def data; {}; end
      def description; end
      def media_url; end
      def published_at; end
      def replaces_page?; false; end
      def text; end
      def title; end

      # Should be supplied as a hash that has the format, and then
      # a set of key=>value formats as strings to be matched for
      # this microparser.
      #
      # The way this parser will work, is that it will look for the
      # the object to match ALL of the critiera in the selector,
      # doing a downcased include? for each of the object's values.
      #
      # For example, for a schema.org ImageObject
      #
      # { "ImageObject" => {"@context" => "schema.org", "@type" => "ImageObject"} }
      #
      # Given this setup, the formatter will match for the @context field
      # with value of "Schema.org" ad well as "schemA.org" and a @type key
      # of "imageobject" or "imageObject" or "ImageObject"
      #
      # As long as ALL values exist.
      #
      # @return [Hash] a specifically configured hash
      def supported_objects
        raise "must be supplied by your child class"
      end

      # #before_parse_actions lets you modify the args that are supplied
      # to make changes before processing. It expects you will work on
      # the @args so no input params are supplied
      #
      # @return [nil]
      def before_parse_actions
      end

      # #after_parse_actions lets you modify the returned hash
      # to make changes after processing
      #
      # @params [Hash] the results that will be returned from formatted
      # @return [Hash] after modifying actions
      def after_parse_actions(final_hash)
        final_hash
      end

      # Iterates over the selected hashes, and takes the first one
      # that matches this list of keys (using dig)
      def first_selected(*keys)
        return nil unless selected_objects.length.positive?

        return_value = nil
        selected_objects.each do |hsh|
          return_value = hsh.dig(*keys)
          break if return_value.present?
        end
        return_value
      end

      # Finds a hash that has the key_value that matches the
      # hsh, and then extracts the keys from that value. Used
      # for cases where the type is stored in a separate branch
      # of the hash tree.
      #
      # Example:
      # {
      #   "interactionStatistic" => {
      #     "@type"=> "InteractionCounter",
      #     "interactionType" => {
      #        "@type"=>"LikeAction"
      #      },
      #     "userInteractionCount"=>"137273"
      #   }
      # }
      #
      # In this case, the method supports this style query
      #
      # $> first_selected_if(["interactionStatistic", "interactionType", "@type"], "LikeAction", "interactionStatistic", "userInteractionCount")
      # $> "137273"
      #
      # @return [String] or nil
      def first_selected_if(check_keys, check_value, *keys)
        return nil unless selected_objects.length.positive?

        return_value = nil
        selected_objects.each do |hsh|
          hash_check_value = hsh.dig(*check_keys)
          next unless hash_check_value == check_value

          return_value = first_selected(*keys)
          break if return_value.present?
        end
        return_value
      end

      # Accessor for the #doc object, which can be used to pull
      # other meta into this microformat to fill it out (often things
      # like the author_iamge_url or an author name might be in other
      # meta elements).
      def doc
        @doc ||= args.dig(:doc)
      end

      # Tries all 3 methods of extracting the meta, until one matched
      # then returns nil if not found
      def get_meta(matcher)
        val = get_meta_name(matcher)
        val = get_meta_property(matcher) if val.blank?
        val = get_meta_itemprop(matcher) if val.blank?
        val
      end

      # Provides the means to query the matc
      def get_meta_name(matcher)
        doc.at("meta[@name='#{matcher}']")&.attr('content')
      end

      # Provides the means to query the matcher from RDF1.0a format
      def get_meta_property(matcher)
        doc.at("meta[@property='#{matcher}']")&.attr('content')
      end

      # Provides the means to query the matcher from RDF1.0a format
      def get_meta_itemprop(matcher)
        doc.at("meta[@itemprop='#{matcher}']")&.attr('content')
      end
    end
  end
end
