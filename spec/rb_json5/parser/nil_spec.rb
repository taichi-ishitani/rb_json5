# frozen_string_literal: true

RSpec.describe 'parser/nil' do
  let(:parser) do
    RbJSON5::Parser.new(:nil)
  end

  it 'should parse nil' do
    expect(parser).to parse('nil').as(&:nil?)
  end
end
