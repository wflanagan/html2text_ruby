module Html2Text
  module Parsers
    module Concerns
      module BaseAccessors
        # This parser requires a Nokogiri Document to be passed to it
        # This methods sets that object. Without this, the system will
        # fail
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
