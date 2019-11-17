# frozen_string_literal: true

RSpec.describe Html2Text do
  context '.convert' do
    let(:text) { ::Html2Text.convert(html) }

    examples = Dir[File.dirname(__FILE__) + '/examples/*.html']
    examples.each do |filename|
      context "#{filename}" do
        let(:html)      { File.read(filename) }
        let(:text_file) { filename.sub('.html', '.txt') }
        let(:expected)  { File.read(text_file) }

        it 'has an expected output' do
          expect(File.exist?(text_file)).to eq(true), "'#{text_file}' did not exist"
        end

        it 'converts to text' do
          # Write the output if it failed, for easier comparison
          # File.open(filename.sub(".html", ".output"), 'w') { |fp| fp.write(text) } if !text.eql?(expected)

          # Quick check, don't try to generate a 500kb+ diff,
          # which can halt the rspec for minutes+
          expect(text.length).to eq expected.length if text.length > 10_000

          # More complete check
          # text.chars.each_with_index { |c, i| puts "output letter: #{c} output byte #{c.bytes} expected byte #{expected.chars[i].bytes} #{c.blank?}"}
          expect(text).to eq expected
        end
      end
    end

    it "has examples to test" do
      expect(examples.size).to_not eq(0)
    end
  end
end
