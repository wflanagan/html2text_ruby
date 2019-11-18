# frozen_string_literal: true

require 'active_support/all'
require 'html2text/utils'
require 'htmlentities'
require 'json'
require 'json/ld'
require 'nokogiri'
require 'rdf/microdata'
require 'microdata'

require 'html2text/html_formatter'
require 'html2text/parsers/concerns/node_utils'
require 'html2text/parsers/html'
require 'html2text/parsers/image_node'
require 'html2text/parsers/json_ld'
require 'html2text/version'

# The main modulee for Html2Text. Wraps the parsers
# and provides a convenicence .convert for backward
# compatibility
module Html2Text
  class << self
    def new(args={})
      Html2Text::Parsers::Html.new(args)
    end

    def convert(html)
      Html2Text::Parsers::Html.new(html: html).call
    end
  end
end
