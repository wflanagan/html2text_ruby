# frozen_string_literal: true

RSpec.describe Html2Text do
  context "#convert" do
    let(:text) { Html2Text.convert(html) }

    context "an empty line" do
      let(:html) { "" }

      it "is an empty line" do
        expect(text).to eq("")
      end
    end

    context "a simple string" do
      let(:html) { "hello world" }

      it "is an empty line" do
        expect(text).to eq("hello world")
      end
    end

    context "input value is non-string" do
      let(:html) { nil }
      it '(nil)' do
        expect(text).to eq("")
      end
    end

    context "input value is non-string" do
      let(:html) { 1234 }
      it "(number)" do
        expect(text).to eq("1234")
      end
    end

    context "input value is non-string" do
      let(:html) { 1234.5600 }
      it "(float number)" do
        expect(text).to eq("1234.56")
      end
    end
  end

  context "#remove_leading_and_trailing_whitespace" do
    let(:subject) { Html2Text::Utils.remove_leading_and_trailing_whitespace(input) }

    context "an empty string" do
      let(:input) { "" }
      it { is_expected.to eq("") }
    end

    context "many new lines" do
      let(:input) { "hello\n  world \n yes" }
      it { is_expected.to eq("hello\nworld\nyes") }
    end
  end
end
