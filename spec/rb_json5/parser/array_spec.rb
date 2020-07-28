# frozen_string_literal: true

RSpec.describe 'parser/array' do
  let(:parser) do
    RbJSON5::Parser.new(:array)
  end

  it 'should parse empty arrays' do
    expect(parser).to parse('[]', trace: true).as([])
  end

  it 'should parse array values' do
    expect(parser).to parse('[1]', trace: true).as([1])
    expect(parser).to parse('[true,false,null]', trace: true).as([true, false, nil])
  end

  it 'should parse nested arrays' do
    expect(parser).to parse('[1,[2,3]]', trace: true).as([1, [2, 3]])
  end

  it 'should parse arrays with an extra comma' do
    expect(parser).to parse('[1,]', trace: true).as([1])
  end
end
