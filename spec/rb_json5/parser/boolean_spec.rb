# frozen_string_literal: true

RSpec.describe 'parser/boolean' do
  let(:parser) do
    RbJSON5::Parser.new(:boolean)
  end

  it 'should parse true' do
    expect(parser).to parse('true', trace: true).as(true)
  end

  it 'should parse false' do
    expect(parser).to parse('false', trace: true).as(false)
  end
end
