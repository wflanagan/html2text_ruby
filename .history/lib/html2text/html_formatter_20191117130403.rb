# frozen_string_literal: true

module Html2Text
  # Modifies the HTML for encoding and other items that is used
  # to parse the page
  class HtmlFormatter
    attr_reader :args

    def initialize(args = {})
      @args = args
    end

    def html
      @html ||= args.dig(:html)
    end

    def call
      formatted_html
    end

    def office_document?
      @office_document ||= html.include?('urn:schemas-microsoft-com:office')
    end

    def html_fragment?
      !html.include?('<html')
    end

    def cast_to_office_document
      html.gsub('<p class=MsoNormal>', '<br>').gsub('<o:p>&nbsp;</o:p>', '<br>').gsub('<o:p></o:p>', '')
    end

    # Does the pre-cleaning needed to ensure we have a good
    # HTML document to to work with.
    #
    # When working in tests and trying to figure out parsing stuff,
    # this is a good place to inspect and ensure that things are
    # handled correctly.
    def formatted_html
      @formatted_html ||= begin
        formatted = html
        formatted = cast_to_office_document if office_document?
        formatted = "<div>#{html}</div>"    if html_fragment?
        formatted = Html2Text::Utils.ensure_valid_encoding(formatted)
        formatted = Html2Text::Utils.replace_entities(formatted)
        formatted = Html2Text::Utils.fix_newlines(formatted)
        formatted = Html2Text::Utils.remove_nonprinting_chars(formatted)
        formatted
      end
    end
  end
end
