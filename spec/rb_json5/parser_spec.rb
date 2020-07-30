# frozen_string_literal: true

RSpec.describe RbJSON5::Parser do
  let(:parser) do
    RbJSON5::Parser.new
  end

  describe 'Example on README' do
    let(:example) do
      <<~'JSON5'
        {
          // comments
          unquoted: 'and you can quote me on that',
          singleQuotes: 'I can use "double quotes" here',
          lineBreaks: "Look, Mom! \
        No \\n's!",
          hexadecimal: 0xdecaf,
          leadingDecimalPoint: .8675309, andTrailing: 8675309.,
          positiveSign: +1,
          trailingComma: 'in objects', andIn: ['arrays',],
          "backwardsCompatible": "with JSON",
        }
      JSON5
    end

    let(:output) do
      {
        'unquoted' => 'and you can quote me on that',
        'singleQuotes' => 'I can use "double quotes" here',
        'lineBreaks' => "Look, Mom! No \\n's!",
        'hexadecimal' => 0xdecaf,
        'leadingDecimalPoint' => 0.8675309,
        'andTrailing' => 8675309.0,
        'positiveSign' => 1,
        'trailingComma' => 'in objects',
        'andIn' => ['arrays'],
        'backwardsCompatible' => 'with JSON'
      }
    end

    it 'should parse the exmaple JSON5 on README' do
      expect(parser).to parse(example, trace: true).as(output)
    end
  end

  describe 'json5-test' do
    let(:valid_json5_files) do
      Dir.chdir(JSON5_TESTS) do
        [*Dir.glob('**/*.json5'), *Dir.glob('**/*.json')]
      end
    end

    let(:invalid_json5_files) do
      Dir.chdir(JSON5_TESTS) do
        [*Dir.glob('**/*.js'), *Dir.glob('**/*.txt')]
      end
    end

    def read_test_file(file)
      File.open(File.join(JSON5_TESTS, file), 'r', &:read)
    end

    it 'should parse valid JSON5 files' do
      valid_json5_files.each do |file|
        valid_json5 = read_test_file(file)
        expect(parser).to parse(valid_json5, trace: true)
      end
    end

    it 'should not parse invalid JSON5 files' do
      invalid_json5_files.each do |file|
        invalid_json5 = read_test_file(file)
        expect(parser).not_to parse(invalid_json5, trace: true)
      end
    end
  end
end
