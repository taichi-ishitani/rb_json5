# frozen_string_literal: true

RSpec.describe 'parser/string' do
  let(:parser) do
    RbJSON5::Parser.new(:string)
  end

  it 'should parse empty stirngs' do
    expect(parser).to parse('""').as('')
    expect(parser).to parse("''").as('')
  end

  it 'should parse double quoted strings' do
    expect(parser).to parse('"abc"', trace: true).as('abc')
  end

  it 'should parse single quoted strings' do
    expect(parser).to parse("'abc'", trace: true).as('abc')
  end

  it 'should parse quotes in strings' do
    { "'\"'" => '"', "\"'\"" => "'" }.each do |input, value|
      expect(parser).to parse(input, trace: true).as(value)
    end
  end

  it 'should parse escaped characters' do
    expect(parser)
      .to parse("'\\b\\f\\n\\r\\t\\v\\0\\x0f\\u01fF\\\n\\\r\n\\\r\\\u2028\\\u2029\\a\\'\\\"'", trace: true)
      .as("\b\f\n\r\t\v\0\x0f\u01ffa'\"")
  end

  it 'should parse line and paragraph separators' do
    expect(parser).to parse('"\\u2028\\u2029"', trace: true).as("\u2028\u2029")
  end
end
