# frozen_string_literal: true

module Html2Text
  module Parsers
    class Sentences < Base
      def call
        cleaned_sentences
      end

      def cleaned_sentences
        @cleaned_sentences ||= begin
          cleaned_sentences = sentences.map do |sentence|
            next if sentence == Html2Text::Utils::HEADER_TAG
            next if nav_sentence?(sentence)

            if header_sentence?(sentence)
              sentence = sentence.gsub(Html2Text::Utils::HEADER_TAG, '')
            else
              next if short_sentence?(sentence)

              sentence
            end
          end
          cleaned_sentences.compact.map { |sentence| sentence.strip }
        end
      end

      def sentences
        @sentences ||= segmenter.segment
      end

      def text
        @text ||= args.dig(:text)
      end

      # Multi-language text splitter. Breaks a text document into sentences.
      #
      # Usage:
      #   segmenter = PragmaticSegmenter::Segmenter.new(text: text)
      #   segmenter.segment
      #     => ['array', 'of', 'sentences']
      #
      # @return [Object] Array of sentences
      def segmenter
        @segmenter ||= PragmaticSegmenter::Segmenter.new(text: text)
      end

      # Boolean to check if this is a header sentence
      #
      # @return [Boolean] true or false
      def header_sentence?(sentence)
        sentence.include?(Html2Text::Utils::HEADER_TAG)
      end

      def nav_sentence?(sentence)
        list_sentence?(sentence) && linked_sentence?(sentence) && short_sentence?(sentence)
      end

      def list_sentence?(sentence)
        sentence.start_with?("-")
      end

      def linked_sentence?(sentence)
        sentence.include?("](")
      end

      def short_sentence?(sentence)
        sentence.gsub(/\[.+\]\(.+\)/, '').length < 30
      end
    end
  end
end
