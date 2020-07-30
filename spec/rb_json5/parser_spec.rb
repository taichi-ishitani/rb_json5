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
end
