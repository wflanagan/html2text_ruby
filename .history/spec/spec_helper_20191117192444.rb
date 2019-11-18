require 'rspec'
require 'rspec/collection_matchers'
require 'http'
require 'pry'

# Load a fixture to test things like JSON-LD
def load_file_from_fixture_path(filename)
  full_filename = File.expand_path(File.join(__dir__, 'fixtures', filename))
  File.read(full_filename)
end

require File.join(File.dirname(__FILE__), '..', 'lib', 'html2text')
