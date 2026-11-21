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
    expect(parser).to parse('"a\\\\b"', trace: true).as('a\\b')

    expect(parser)
      .to parse("'\\b\\f\\n\\r\\t\\v\\0\\x0f\\u01fF\\\n\\\r\n\\\r\\\u2028\\\u2029\\a\\'\\\"'", trace: true)
      .as("\b\f\n\r\t\v\0\x0f\u01ffa'\"")
  end

  it 'should parse line and paragraph separators' do
    expect(parser).to parse('"\\u2028\\u2029"', trace: true).as("\u2028\u2029")
  end

  it 'should parse surrogate pairs' do
    expect(parser).to parse('"\\ud83d\\ude00"', trace: true).as("\u{1f600}")
    expect(parser).to parse("'\\uD834\\uDD1E\\u0041'", trace: true).as("\u{1d11e}A")
    expect(parser).to parse('"a\\ud83d\\ude00b\\ud83d\\ude01"', trace: true).as("a\u{1f600}b\u{1f601}")
  end

  it 'should parse hex escapes above 0x7F' do
    expect(parser).to parse("'\\xe9\\xFF'", trace: true).as("\u00e9\u00ff")
  end

  it 'should not parse unpaired surrogates' do
    ['"\\ud83d"', '"\\ude00"', '"\\ud83dx"', '"\\ude00\\ud83d"', '"\\ud83d\\u0041"'].each do |input|
      expect { RbJSON5.parse(input) }.to raise_error(RbJSON5::ParseError)
    end
  end
end
