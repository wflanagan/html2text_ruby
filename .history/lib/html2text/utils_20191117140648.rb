# frozen_string_literal: true

module Html2Text
  # Extracts commonly used utilities that are text-related into
  # a common Utils module that can be mixed into any parser
  # that is used in the Gem.
  module Utils
    DO_NOT_TOUCH_WHITESPACE = "<do-not-touch-whitespace>"

    class << self
      # Originally, I added a bunch of text here to lookup the charset
      # from the string that encoded it to that format. However, this
      # overhead adds a lot of edge cases themselves, when we can just
      # force everything to UTF-8 and this will work 99.99% of the time.
      # So, I've modified to do this.
      #
      # @return [String] converted to UTF-8 string
      def ensure_valid_encoding(text)
        force_to_utf8(text)
      end

      # Forces the text to UTF-8 in the best way we know how, without any
      # character encoding. There is a gem called utf8_utils that is
      # supposedly faster and more complete than this. But, if this works
      # OK then no point in adding the memory and load overhead.
      def force_to_utf8(text)
        ActiveSupport::Multibyte::Unicode.tidy_bytes(text)
      end

      # Removes non-printing characters from a string. We do this after
      # we do base encoding to try to make us have a consistent string
      # length in tests, and because these characters, while not showing
      # can do weird things to formatting in certain circumstances.
      def remove_nonprinting_chars(text)
        return text if text.blank?

        text.chars.map { |char| rejected_char?(char) ? ' ' : char }.join
      end

      def rejected_char?(char)
        (char.blank? && !["\n", "\t", "\r"].include?(char))
      end

      # Takes up to the first 5,000 characters of the text, forces the
      # encoding to UTF-8, and then scans it looking for a charset.
      # If the charset is provided, then it will transform this
      # into a RUby style label that can be used to encode the text
      # to the appropriate format, so we can try to maintain all the
      # text in a clean way.
      def extract_charset_from_text(text)
        force_to_utf8(text.to_s&.first(5_000))&.scan(%r{<meta(?!\s*(?:name|value)\s*=)[^>]*?charset\s*=[\s"']*([^\s"'\/>]*)})
                                              &.first
                                              &.upcase
                                              &.gsub('-', '_')
      rescue ArgumentError => e
        raise e unless e.to_s.include?('invalid byte')

        nil
      end

      # checks if the last character of a string is punctuation
      def ends_with_punctuation?(text)
        text.chars.last.scan(/[[:punct:]]/u).length.positive?
      end

      # Replace whitespace characters with a space (equivalent to \s)
      # and force any text encoding into UTF-8
      def trimmed_whitespace(text)
        text.gsub(/[\t\n\f\r ]+/ium, ' ')
      end

      def fix_newlines(text)
        return text if text.blank?

        text.gsub("\r\n", "\n").gsub("\r", "\n")
      end

      # We need to use a broader reach item. But, HTMLEntities will
      # handle and try to fix items inside of a pre, which is incorrect
      def replace_entities(text)
        return text if text.blank?

        text = text.gsub("&nbsp;", " ").gsub("\u00a0", " ").gsub("&zwnj;", "")
        # text = HTMLEntities.new.decode(text)
        text
      end

      def remove_unnecessary_empty_lines(text)
        return text if text.blank?

        text.gsub(/\n\n\n*/im, "\n\n")
      end

      # ignores any <pre> blocks, which we don't want to interact with
      def remove_leading_and_trailing_whitespace(text)
        pre_blocks = text.split(DO_NOT_TOUCH_WHITESPACE)

        output = []
        pre_blocks.each.with_index do |block, index|
          if index % 2 == 0
            output << block.gsub(/[ \t]*\n[ \t]*/im, "\n").gsub(/ *\t */im, "\t")
          else
            output << block
          end
        end

        output.join
      end

      # Hash that stores the prefix whitespace options. Makes the code easier to read
      # and understand.
      def prefix_whitespace_options
        { 'hr' => "\n---------------------------------------------------------------\n",
          'h1' => "\n\n",
          'h2' => "\n\n",
          'h3' => "\n\n",
          'h4' => "\n\n",
          'h5' => "\n\n",
          'h6' => "\n\n",
          'ol' => "\n\n",
          'ul' => "\n\n",
          'p'  => "\n\n",
          'td' => "\t",
          'th' => "\t",
          'li' => '- ' }
      end

      def suffix_whitespace_options
        { 'h1' => "\n\n",
          'h2' => "\n\n",
          'h3' => "\n\n",
          'h4' => "\n\n",
          'h5' => "\n\n",
          'h6' => "\n\n",
          'p'  => "\n\n",
          'li' => "\n"}
      end
    end
  end
end
