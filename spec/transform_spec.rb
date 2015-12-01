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
  context 'if' do
    it 'returns an if object' do
      expect(trans("if (true) { a = 1 }")).to be_a(If)
      expect(trans("if (true) {
        a = 1
        b = 2
      }")).to be_a(If)
    end
  end
  context 'if else' do
    it 'returns an if with else object' do
      expect(trans("if (true) {
        a = 1
      } else {
        b = 1
      }")).to be_a(If)
      expect(trans("if (true) {
        a = 1
      } else {
        b = 1
      }")).to be_a(If)
    end
  end
  context 'function' do
    it 'returns a function object' do
      expect(trans("fn (x:Int):Int { x }")).to be_a(Function)
      expect(trans("fn ():Int {
        x
        x
      }")).to be_a(Function)
    end
  end
  context 'call' do
    it 'returns a call object' do
      expect(trans("first()")).to be_a(Call)
      expect(trans("first(x, 10, \"foobar\")")).to be_a(Call)
    end
  end
  context 'boolean' do
    it 'returns true object' do
      expect(trans("true")).to be_a(True)
    end
    it 'returns false object' do
      expect(trans("false")).to be_a(False)
    end
  end
end
