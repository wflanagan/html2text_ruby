require 'rspec'
require 'rspec/collection_matchers'
require 'http'
require 'pry'

# Load a fixture to test things like JSON-LD
def load_file_from_fixture_path(filename)
  full_filename = File.expand_path(File.join(__dir__, 'fixtures', filename))
  File.read(full_filename)
end

module HashExpectationHelper
  def expect_to_have_keys_present(hsh, *keys)
    expect(hsh).to be_present
    keys.each { |key| expect(hsh[key]).to be_present }
  end
end

RSpec.configure do |config|
  config.include HashExpectationHelper
end

require File.join(File.dirname(__FILE__), '..', 'lib', 'html2text')
