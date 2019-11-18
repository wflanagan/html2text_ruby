module Html2Text
  module Parsers
    module Concerns
      module BaseAccessors
        # Parsers generally use a Nokogiri Document.
        # This methods sets that object. Without this, the system will
        # fail unless it's the HTML parser, which generates the
        # doc in the first place.
        #
        # @return [Object] Nokogiri object
        def doc
          @doc ||= args.dig(:doc)
        end

        def html
          @html ||= args.dig(:html) || doc.to_html
        end

        def url
          @url ||= args.dig(:url)
        end
      end
    end
  end
end
