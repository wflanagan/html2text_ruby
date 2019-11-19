# frozen_string_literal: true

RSpec.describe "html5 test" do
  let(:html) { load_file_from_fixture_path("html/html5_test.html") }

  context "setup" do
    let(:parser) { Html2Text.new(html: html) }
    it "does not explode" do
      expect{ parser.text }.to_not raise_error
    end
  end

  context "header_tagging" do
    let(:parser) { Html2Text.new(html: html, tag_headings: true) }

    it "does not explode" do
      resp = parser.text
      binding.pry
    end
  end
end
