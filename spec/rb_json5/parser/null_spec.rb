# frozen_string_literal: true

RSpec.describe 'parser/null' do
  let(:parser) do
    RbJSON5::Parser.new(:null)
  end

  it 'should parse null' do
    expect(parser).to parse('null').as(&:nil?)
  end
end
