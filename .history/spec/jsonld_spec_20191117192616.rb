# frozen_string_literal: true

RSpec.describe "fixes" do
  let(:parser) { Html2Text.convert(html) }

  context 'instagram' do
    context 'photo' do
      let(:html) { load_file_from_fixture_path("instagram_photo.html") }

      xit "ld+json is added to the text" do
      end
    end
  end
end
