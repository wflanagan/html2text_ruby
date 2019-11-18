# frozen_string_literal: true

module Html2Text
  module Parsers
    module Concerns
      # As most of the parsing is done on Nokogiri::Document
      # nodes, this is a mixin that provides all the helpers
      # that can be used to query the nodes for particular
      # types of data.
      module NodeUtils
        # Looks at the type of node (a, div, span, tr, etc.)
        # and checks if the requested type is of the same
        # type
        #
        # @return [Boolean] true or false
        def node_kind?(node, type)
          node.name.downcase == type.to_s
        end

        # Looks at the type of node's parent node
        # (a, div, span, tr, etc.)
        # and checks if the requested type is of the same
        # type
        #
        # @return [Boolean] true or false
        def node_parent_kind?(node, type)
          node.parent.name.downcase == type.to_s
        end

        # In iterating over the document, we look to see
        # if previous node was a text node (the actual containing)
        # text of a parent node, or not.
        #
        # @return [Boolean] true or false
        def previous_node_is_text?(node)
          !node.previous_sibling.nil? && node.previous_sibling.text? && !node.previous_sibling.text.strip.empty?
        end

        # Returns true if the node is not the type that would have
        # any sort of printable text.
        #
        # @return [Boolean] true or false
        def non_printable_node?(node)
          %w[style head title meta script].include?(node.name.downcase)
        end

        # Returns true if the node is not a div, AND it not nil.
        #
        # @return [Boolean] true or false
        def next_node_not_div_or_nil?(node)
          next_node_name(node) != 'div' && next_node_name(node) != nil
        end

        # Returns the name of the next node (a, tr, div, span, etc.)
        #
        # @return [String] next node's name (type)
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

        # Returns the name of the previous node (a, tr, div, span, etc.)
        #
        # @return [String] next node's name (type) or nil
        def previous_node_name(node)
          previous_node = node.previous_sibling
          while !previous_node.nil?
            break if previous_node.element?

            previous_node = previous_node.previous_sibling
          end

          previous_node&.name&.downcase if previous_node&.element?
        end

        # If the next node is a text node, this returns
        # true
        #
        # @return [Boolean] true or false
        def next_node_is_text?(node)
          !node.next_sibling.nil? && node.next_sibling.text? && !node.next_sibling.text.strip.empty?
        end

        # Checks if the parent node to this node has the same
        # text as the child node. Used to ensure that we don't
        # create duplicate text on text extraction.
        #
        # @return [Boolean] true or false
        def node_and_parent_same_text?(node)
          node.parent.text.strip == node.text.strip
        end

        # Iterates over a set of matchers, and then
        # returns the final result set extracted from
        # the document.
        #
        # Expects the #doc to be present and available
        # to the method. If #doc is nil or undefined
        # this method will error.
        #
        # @return [Array] array of matches
        def doc_matches(matchers)
          matches = []
          matchers.each do |query|
            if query.is_a?(String)
              if el = doc.search(query).first
                if el.name.downcase == "meta"
                  matches << el["content"]
                else
                  matches << el.inner_text
                end
              end
            elsif query.is_a?(Array)
              doc.search(query.first).map do |node|
                el = query.last.call(node)
                matches << el if el.present?
              end
            end
          end
          matches.flatten
        rescue => e
          puts "#{e.message}"
          []
        end
      end
    end
  end
end
