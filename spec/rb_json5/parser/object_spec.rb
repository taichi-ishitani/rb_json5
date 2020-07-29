# frozen_string_literal: true

RSpec.describe 'parser/object' do
  let(:parser) do
    RbJSON5::Parser.new(:object)
  end

  it 'should parse empty objects' do
    expect(parser).to parse('{}', trace: true).as({})
  end

  it 'should parse double string property names' do
    expect(parser).to parse('{"a":1}', trace: true).as({ 'a' => 1 })
  end

  it 'should parse single string property names' do
    expect(parser).to parse("{'a':1}", trace: true).as({ 'a' => 1 })
  end

  it 'should parse unquoted property names' do
    expect(parser).to parse('{a:1}', trace: true).as({ 'a' => 1 })
  end

  it 'should parse multiple properties' do
    expect(parser).to parse('{abc:1,def:2}', trace: true).as({ 'abc' => 1, 'def' => 2 })
  end

  it 'should parse nested objects' do
    expect(parser).to parse('{a:{b:2}}', trace: true).as({ 'a' => { 'b' => 2 } })
  end

  it 'should parse special character property names' do
    expect(parser)
      .to parse("{$_:1,_$:2,a\u200C:3}", trace: true)
      .as({ '$_' => 1, '_$' => 2, "a\u200c" => 3 })
  end

  it 'should parse unicode property names' do
    expect(parser).to parse('{ùńîċõďë:9}', trace: true).as({ 'ùńîċõďë' => 9 })
  end

  it 'should parse escaped property names' do
    expect(parser)
      .to parse('{\\u0061\\u0062:1,\\u0024\\u005F:2,\\u005F\\u0024:3}', trace: true)
      .as({ 'ab' => 1, '$_' => 2, '_$' => 3 })
  end

  it 'should parse objects with an extra comma' do
    expect(parser).to parse('{a:1,}', trace: true).as({ 'a' => 1 })
    expect(parser).to parse('{b:2,c:3,}', trace: true).as({ 'b' => 2, 'c' => 3 })
  end
end
