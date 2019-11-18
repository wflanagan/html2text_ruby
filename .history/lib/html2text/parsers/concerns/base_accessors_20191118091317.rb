module Html2Text
  module Parsers
    module Concerns
      module BaseAccessors
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
