# frozen_string_literal: true

RSpec.describe 'fixes' do
  let(:parser) { Html2Text.new(html: html) }

  context 'instagram' do
    context 'photo' do
      let(:html) { load_file_from_fixture_path("instagram_photo.html") }

      it "ld+json is added to the text" do
        parser
        binding.pry
      end
    end
  end
end
