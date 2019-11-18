module Html2Text
  module Parsers
    module Concerns
      module NodeUtils
        def node_kind?(node, type)
          node.name.downcase == type.to_s
        end

        def node_parent_kind?(node, type)
          node.parent.name.downcase == type.to_s
        end

        def previous_node_is_text?(node)
          !node.previous_sibling.nil? && node.previous_sibling.text? && !node.previous_sibling.text.strip.empty?
        end

        def non_printable_node?(node)
          %w[style head title meta script].include?(node.name.downcase)
        end

        def next_node_not_div_or_nil?(node)
          next_node_name(node) != 'div' && next_node_name(node) != nil
        end

        def next_node_name(node)
          next_node = node.next_sibling
          while next_node != nil
            break if next_node.element?
            next_node = next_node.next_sibling
          end

          if next_node && next_node.element?
            next_node.name.downcase
          end
        end

        def next_node_is_text?(node)
          !node.next_sibling.nil? && node.next_sibling.text? && !node.next_sibling.text.strip.empty?
        end

        def node_and_parent_same_text?(node)
          node.parent.text.strip == node.text.strip
        end

        def previous_node_name(node)
          previous_node = node.previous_sibling
          while !previous_node.nil?
            break if previous_node.element?

            previous_node = previous_node.previous_sibling
          end

          previous_node&.name&.downcase if previous_node&.element?
        end

        # Expects a doc object to be present for this to work
        def doc_matches(matchers)
          matches = []
          *matchers.each do |query|
            if query.is_a?(String)
              if el = doc.search(query).first
                if el.name.downcase == "meta"
                  el["content"]
                else
                  el.inner_text
                end
              end
            elsif query.is_a?(Array)
              doc.search(query.first).map do |node|
                query.last.call(node)
              end
            end
            binding.pry
          end
        rescue => e

            nil
          end
        end
      end
    end
  end
end
