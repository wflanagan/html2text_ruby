module Html2Text
  module Parsers
    module Concerns
      module NodeUtils
        def node_kind?(node, type)
          node.name.downcase == type.to_s
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
          return !node.next_sibling.nil? && node.next_sibling.text? && !node.next_sibling.text.strip.empty?
        end

        def node_and_parent_same_text?(node)
          node.parent.text.strip == node.text.strip
        end

        def previous_node_name(node)
          previous_node = node.previous_sibling
          while previous_node != nil
            break if previous_node.element?
            previous_node = previous_node.previous_sibling
          end

          if previous_node && previous_node.element?
            previous_node.name.downcase
          end
        end
      end
    end
  end
end
