# frozen_string_literal: true

RSpec.describe RbJSON5 do
  describe '.parse/.load_file' do
    let(:input) do
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

    let(:input_io) do
      StringIO.new(input)
    end

    let(:output) do
      {
        'unquoted' => 'and you can quote me on that',
        'singleQuotes' => 'I can use "double quotes" here',
        'lineBreaks' => "Look, Mom! No \\n's!",
        'hexadecimal' => 0xdecaf,
        'leadingDecimalPoint' => 0.8675309,
        'andTrailing' => 8_675_309.0,
        'positiveSign' => 1,
        'trailingComma' => 'in objects',
        'andIn' => ['arrays'],
        'backwardsCompatible' => 'with JSON'
      }
    end

    let(:output_with_symblize_names) do
      output.map { |k, v| [k.to_sym, v] }.to_h
    end

    describe '.parse' do
      it 'should parse JSON5 string' do
        expect(RbJSON5.parse(input)).to eq output
      end

      it 'should parse JSON5 string got from the given IO' do
        expect(RbJSON5.parse(input_io)).to eq output
      end

      context 'when \'symbolize_names\' is set to true' do
        specify 'property names should be converted into Symbol' do
          expect(RbJSON5.parse(input, symbolize_names: true)).to eq output_with_symblize_names
          expect(RbJSON5.parse(input_io, symbolize_names: true)).to eq output_with_symblize_names
        end
      end
    end

    describe '.load_file' do
      let(:file_name) do
        'test.json5'
      end

      before do
        io = StringIO.new(input)
        allow(File).to receive(:open).with(file_name, 'r').and_yield(io)
      end

      it 'should load JSON5 from the specified file' do
        expect(RbJSON5.load_file(file_name)).to eq output
      end

      context 'when \'symbolize_names\' is set to true' do
        specify 'property names should be converted into Symbol' do
          expect(RbJSON5.load_file(file_name, symbolize_names: true)).to eq output_with_symblize_names
        end
      end
    end
  end

  describe 'json5-tests' do
    let(:valid_files) do
      Dir.chdir(JSON5_TESTS) do
        [*Dir.glob('**/*.json5'), *Dir.glob('**/*.json')]
      end
    end

    let(:invalid_files) do
      Dir.chdir(JSON5_TESTS) do
        [*Dir.glob('**/*.js'), *Dir.glob('**/*.txt')]
      end
    end

    def read_file(path)
      File.open(File.join(JSON5_TESTS, path), 'r', &:read)
    end

    it 'should parse valid JSON5 files' do
      valid_files.each do |file|
        expect(RbJSON5).to parse(read_file(file), trace: true)
      end
    end

    it 'should not parse invalid JSON5 files' do
      invalid_files.each do |file|
        expect(RbJSON5).not_to parse(read_file(file), trace: true)
      end
    end
  end
end
