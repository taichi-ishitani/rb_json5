# frozen_string_literal: true

RSpec.describe 'parse error' do
  let(:parser) do
    RbJSON5::Parser.new
  end

  it 'should not parse empty documents' do
    expect(parser).not_to parse('', trace: true)
  end

  it 'should not parse documents with only comments' do
    expect(parser).not_to parse('//a', trace: true)
  end

  it 'should not parse incomplete single line comments' do
    expect(parser).not_to parse('/a', trace: true)
  end

  it 'should not parse unterminated multiline comments' do
    expect(parser).not_to parse('/*', trace: true)
  end

  it 'should not parse unterminated multiline comment closings' do
    expect(parser).not_to parse('/**', trace: true)
  end

  it 'should not parse invalid characters in value' do
    expect(parser).not_to parse('a', trace: true)
  end

  it 'should not parse invalid characters in identifier start escapes' do
    expect(parser).not_to parse('{\\a:1}', trace: true)
  end

  it 'should not parse invalid identifier start character' do
    expect(parser).not_to parse('{\\u0021:1}', trace: true)
  end

  it 'should not parse invalid characters in identifier continue escapes' do
    expect(parser).not_to parse('{a\\a:1}', trace: true)
  end

  it 'should not parse invalid identifier continue characters' do
    expect(parser).not_to parse('{a\\u0021:1}', trace: true)
  end

  it 'should not parse invalid characters following a sign' do
    expect(parser).not_to parse('-a', trace: true)
  end

  it 'should not parse invalid characters following a leading decimal point' do
    expect(parser).not_to parse('.a', trace: true)
  end

  it 'shuuld not parse invalid characters following an exponent indicator' do
    expect(parser).not_to parse('1ea', trace: true)
  end

  it 'should not parse invalid characters following an exponent sign' do
    expect(parser).not_to parse('1e-a', trace: true)
  end

  it 'should not parse invalid characters following a hexadecimal indicator' do
    expect(parser).not_to parse('0xg', trace: true)
  end

  it 'should not parse invalid new lines in strings' do
    expect(parser).not_to parse("'\n'", trace: true)
  end

  it 'should not parse unterminated strings' do
    expect(parser).not_to parse('"', trace: true)
  end

  it 'should not parse invalid identifier start characters in property names' do
    expect(parser).not_to parse('{!:1}', trace: true)
  end

  it 'should not parse invalid characters following a property name' do
    expect(parser).not_to parse('{a!1}', trace: true)
  end

  it 'should not parse invalid characters following a property value' do
    expect(parser).not_to parse('{a:1!}', trace: true)
  end

  it 'should not parse invalid characters following an array value' do
    expect(parser).not_to parse('[1!]', trace: true)
  end

  it 'should not parse invalid characters in literals' do
    expect(parser).not_to parse('tru!', trace: true)
    expect(parser).not_to parse('fals!', trace: true)
    expect(parser).not_to parse('nul!', trace: true)
  end

  it 'should not parse unterminated escapes' do
    expect(parser).not_to parse('"\\"', trace: true)
  end

  it 'should not parse invalid first digits in hexadecimal escapes' do
    expect(parser).not_to parse('"\\xg"', trace: true)
  end

  it 'should not parse invalid second digits in hexadecimal escapes' do
    expect(parser).not_to parse('"\\x0g"', trace: true)
  end

  it 'should not parse invalid unicode escapes' do
    expect(parser).not_to parse('"\\u000g"', trace: true)
  end

  it 'should not parse escaped digits other than 0' do
    1.upto(9).each do |i|
      expect(parser).not_to parse("'\\#{i}'", trace: true)
    end
  end

  it 'should not parse octal escapes' do
    expect(parser).not_to parse("'\\01'", trace: true)
  end

  it 'should not parse multiple values' do
    expect(parser).not_to parse('1 2', trace: true)
  end

  it 'should not parse control characters escaped in the message' do
    expect(parser).not_to parse("\x01", trace: true)
  end

  it 'should not parse unclosed objects before property names' do
    expect(parser).not_to parse('{', trace: true)
  end

  it 'should not parse unclosed objects after property names' do
    expect(parser).not_to parse('{a', trace: true)
  end

  it 'should not parse unclosed objects before property values' do
    expect(parser).not_to parse('{a:', trace: true)
  end

  it 'should not parse unclosed objects after property values' do
    expect(parser).not_to parse('{a:1', trace: true)
  end

  it 'should not parse unclosed arrays before values' do
    expect(parser).not_to parse('[', trace: true)
  end

  it 'should not parse unclosed arrays after values' do
    expect(parser).not_to parse('[1', trace: true)
  end
end
