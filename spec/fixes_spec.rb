require "spec_helper"

def load_file_from_fixture_path(filename)
  full_filename = File.expand_path(File.join(__dir__, 'fixtures', filename))
  File.read(full_filename)
end

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
