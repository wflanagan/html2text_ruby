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

  context 'instagram' do
    context 'photo' do
      let(:html) { load_file_from_fixture_path("html/instagram_photo.html") }
      let(:resp) { parser.microformats.image_object }

      it "schema.org/ImageObject parses" do
        %i[url title text].each { |key| expect(resp.dig(key)).to be_present }
        expect(resp.dig(:author, :profile_url)).to be_present
      end
    end

    context 'video' do
      let(:html) { load_file_from_fixture_path("html/instagram_video.html") }
      let(:resp) { parser.microformats.video_object }

      it "schema.org/ImageObject parses" do
        %i[url title text].each { |key| expect(resp.dig(key)).to be_present }
        expect(resp.dig(:author, :profile_url)).to be_present
      end
    end
  end
end
