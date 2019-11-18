module Html2Text
  module Parsers
    module Concerns
      module BaseAccessors
        # Parsers generally use a Nokogiri Document.
        #
        # This methods sets that object. Without this, the system will
        # fail unless it's the HTML parser, which generates the
        # doc in the first place.
        #
        # @return [Object] Nokogiri object
        def doc
          @doc ||= args.dig(:doc)
        end

        # Provides either the passed in HTML, or uses
        # the doc to generate the HTML
        #
        # @return [String] HTML source code
        def html
          @html ||= args.dig(:html) || doc.to_html
        end

        # If the URL is passed in, we have acccess to
        # it
        #
        # @return [String] URL
        def url
          @url ||= args.dig(:url)
        end
      end
    end
  end
end
