# frozen_string_literal: true

RSpec.describe Html2Text::Microformatters::Thing do
  let(:object) { JSON.parse(load_file_from_fixture_path("schema/Thing/Thing.jsonld")) }
  let(:parser) { described_class.new(objects: [object]) }
  let(:parsed) { parser.call }

  it "parses" do
    expect_to_have_keys_present(parsed, :content_type, :description, :url, :title, :media_url)
  end
end
