# frozen_string_literal: true

require 'active_support/all'
require 'chronic'
require 'htmlentities'
require 'json'
require 'nokogiri'
require 'pragmatic_segmenter'

require 'html2text/version'
require 'html2text/utils'
require 'html2text/formatters/html'
require 'html2text/microformatters/microformat_base'
require 'html2text/microformatters/thing'
require 'html2text/microformatters/article'
require 'html2text/microformatters/media_object'
require 'html2text/microformatters/image_object'
require 'html2text/microformatters/video_object'
require 'html2text/microformatters/audio_object'
require 'html2text/parsers/concerns/node_utils'
require 'html2text/parsers/concerns/base_accessors'
require 'html2text/parsers/node_parser'
require 'html2text/parsers/base'
require 'html2text/parsers/html'
require 'html2text/parsers/html/a_node'
require 'html2text/parsers/html/image_node'
require 'html2text/parsers/html/title'
require 'html2text/parsers/html/description'
require 'html2text/parsers/microformats'
require 'html2text/parsers/sentences'

# The main modulee for Html2Text. Wraps the parsers
# and provides a convenicence .convert for backward
# compatibility
module Html2Text
  class << self
    def new(args = {})
      Html2Text::Parsers::Html.new(args)
    end

    def convert(html)
      Html2Text::Parsers::Html.new(html: html).call
    end
  end
end
