# frozen_string_literal: true

RSpec.describe 'parser/number' do
  let(:parser) do
    RbJSON5::Parser.new(:number)
  end

  it 'should parse leading zeros' do
    { '0' => 0, '0.' => 0.0, '0e0' => 0.0 }.each do |input, value|
      expect(parser).to parse(input, trace: true).as(value)
    end
  end

  it 'should parse integers' do
    ['1', '23', '456', '7890'].each do |input|
      expect(parser).to parse(input, trace: true).as(input.to_i)
    end
  end

  it 'should parse signed numbers' do
    {'-1' => -1, '+2' => 2, '-.1' => -0.1, '-0' => 0 }.each do |input, value|
      expect(parser).to parse(input, trace: true).as(value)
    end
  end

  it 'should parse leading decimal points' do
    ['.1', '.23'].each do |input|
      expect(parser).to parse(input, trace: true).as(input.to_f)
    end
  end

  it 'should parse fractional numbers' do
    ['1.0', '1.23'].each do |input|
      expect(parser).to parse(input, trace: true).as(input.to_f)
    end
  end

  it 'should parse exponents' do
    ['1e0', '1e1', '1e01', '1.e0', '1.1e0', '1e-1', '1e+1', '+1.23e100'].each do |input|
      expect(parser).to parse(input, trace: true).as(input.to_f)
    end
  end

  it 'should parse hexadecimal numbers' do
    ['0x1', '0x10', '0xff', '0xFF', '-0x0123456789abcdefABCDEF'].each do |input|
      expect(parser).to parse(input, trace: true).as(input.to_i(16))
    end
  end

  it 'should parse signed and unsigned Infinity' do
    {
      'Infinity' => Float::INFINITY,
      '+Infinity' => Float::INFINITY,
      '-Infinity' => -Float::INFINITY
    }.each do |input, value|
      expect(parser).to parse(input, trace: true).as(value)
    end
  end

  it 'should parse NaN and signed NaN' do
    ['NaN', '+NaN', '-NaN'].each do |input|
      expect(parser).to parse(input, trace: true).as(&:nan?)
    end
  end
end
