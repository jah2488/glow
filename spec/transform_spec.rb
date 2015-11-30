require 'spec_helper'
require 'parslet/rig/rspec'

def p(src)
  GLParser.new.parse(src).first
end

def trans(src)
  @trans ||= GLTransform.new
  @trans.apply(p(src))
end


RSpec.describe GLTransform do
  context 'assign' do
    it 'returns an assign object' do
      expect(trans("10")).to be_a(Number)
    end
  end
  context 'function' do
    it 'returns a function object' do
      expect(trans("fn (x:Int):Int { x }")).to be_a(Function)
      expect(trans("fn ():Int { x }")).to be_a(Function)
    end
  end
  context 'call' do
    it 'returns a call object' do
      expect(trans("first()")).to be_a(Call)
      expect(trans("first(x, 10, \"foobar\")")).to be_a(Call)
    end
  end
end
