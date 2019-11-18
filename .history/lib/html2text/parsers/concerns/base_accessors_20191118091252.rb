module Html2Text
  module Parsers
    module Concerns
      module BaseAccessors
        def doc
          @doc ||= args.dig(:doc)
        end

        def html
          @html ||= args.dig(:doc)
        end
      end
    end
  end
end
