# frozen_string_literal: true

RSpec.describe 'fixes' do
  let(:parser) { Html2Text.new(html: html) }

  context "reddit" do
    context "page" do
      let(:html) { load_file_from_fixture_path("html/reddit_page.html") }
      xit "parses with nice text" do
        parser
      end
    end
  end
end

