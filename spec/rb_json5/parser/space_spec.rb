# frozen_string_literal: true

RSpec.describe 'parser/space' do
  let(:parser) do
    RbJSON5::Parser.new
  end

  it 'should parse whitespace' do
    expect(parser).to parse("{\t\v\f \u00A0\uFEFF\n\r\u2028\u2029\u2003}", trace: true).as({})
    expect(parser).to parse("[\t\v\f \u00A0\uFEFF\n\r\u2028\u2029\u2003]", trace: true).as([])
  end

  it 'should parse single-line comments' do
    expect(parser).to parse("{//comment\n}", trace: true).as({})
    expect(parser).to parse("[//comment\n]", trace: true).as([])
  end

  it 'should parse single-line comments at end of input' do
    expect(parser).to parse('{}//comment', trace: true).as({})
    expect(parser).to parse('[]//comment', trace: true).as([])
  end

  it 'should parse multi-line comments' do
    expect(parser).to parse("{/*comment\n** / */}", trace: true).as({})
    expect(parser).to parse("[/*comment\n** / */]", trace: true).as([])
  end
end
