require 'spec_helper'
require 'parslet/rig/rspec'
RSpec.describe Booleans do
  let(:parser) { Booleans.new }
  context 'booleans' do
    it 'consumes true' do
      expect(parser.boolean).to(parse("true"))
    end
    it 'consumes false' do
      expect(parser.boolean).to(parse("false"))
    end
    it 'consumes and' do
      expect(parser.boolean).to parse("and")
      expect(parser.boolean).to parse("&&")
    end

    it 'consumes or' do
      expect(parser.boolean).to parse("or")
      expect(parser.boolean).to parse("||")
    end
  end
end
RSpec.describe GLParser do
  let(:parser) { GLParser.new }

  context 'strings' do
    it 'consume quoted strings' do
      expect(parser.string).to parse('""')
      expect(parser.string).to parse('"A"')
      expect(parser.string).to parse('"Hello world"')
    end
  end
  context 'number' do
    it 'consume integers' do
      expect(parser.number).to parse("89")
      expect(parser.number).to parse("100000000")
      expect(parser.number).to parse("0")
    end
  end
  context 'conditionals' do
    context 'if' do
      it 'consumes if statements' do
        expect(parser.body_if).to parse("if (true) { a = 1 }")
        expect(parser.body_if).to parse("if (false) {
          a = 1
        }")
      end
    end
    context 'else' do
      it 'handles if statements with else clauses' do
        expect(parser.body_if).to parse("if (true) { a = 1 } else { b = 1 }")
        expect(parser.body_if).to parse("if (false) { x } else { y }")
        expect(parser.body_if).to parse("if (true) {
          a = 1
        } else {
          b = 1
        }")
      end
    end

    context 'case when' do

    end
  end
  context 'functions' do
    context 'fn' do
      it 'allow fn or -> literal' do
        expect(parser.fn).to parse("fn")
        expect(parser.fn).to parse("fn ")
        expect(parser.fn).to parse("->")
        expect(parser.fn).to parse("-> ")
      end
    end
    context 'params' do
      it 'allows typed params' do
        expect(parser.params).to parse('()')
        expect(parser.params).to parse('(a:String)')
        expect(parser.params).to parse('(a:String, b:Int)')
      end
      context 'allows function signatures' do
        it { expect(parser.params).to parse('(formatter:(Str):Str)') }
        it 'can handle nested functions' do
          expect(parser.params).to parse('(gen:(Int):(Int):Str)')
        end
        it 'can handle overly complicated functions' do
          expect(parser.params).to parse('(gen:((Num):Str):(Num):Str)')
        end
        it 'permits type passthrough' do #TODO: Find out what this is called
          expect(parser.params).to parse('(a:<T>, b:<D>)')
        end
        # it { expect(parser.params).to parse('(a):a') }
        it { expect(parser.type_param).to parse('<T>') }
      end
      context 'param' do
        it 'parses type and name' do
          expect(parser.param).to parse('a:Int')
          expect(parser.param).to parse('foobar:User')
        end
      end
    end
    context 'function body' do
      it 'parses the function body as a series of expressions' do
        expect(parser.body).to parse('{ a = "hello" }')
        expect(parser.body).to parse("""{
          first = fn (a:Int, b:Int):Int { a }
          first(1, 2)
        }""")
      end
    end
    context 'anonymous functions' do
      it 'allow function definition' do
        expect(parser.function).to parse("fn(a:Int):Int { a }")
        expect(parser.function).to parse('fn(a:(Int):Int):Int { a() }')
      end
      it { expect(parser.function).to parse("fn ():Int { 10 }")   }
      it { expect(parser.function).to parse("fn():Int { 10 }")    }
      it { expect(parser.function).to parse("fn () :Int { 10 }")  }
      it { expect(parser.function).to parse("fn () : Int { 10 }") }

      it { expect(parser.function).to parse("fn (a:Int):Int { a }")        }
      it { expect(parser.function).to parse("fn ( a : Int ):Int { a }")    }
      it { expect(parser.function).to parse("fn (a:Int, b:User):Int { a }")       }
      it { expect(parser.function).to parse("fn ( a : Int, b : User ):Int { a }") }
    end
    context 'named functions' do
      it { expect(parser.named_function).to parse("fn zero():Int { 0 }") }
      it { expect(parser.named_function).to parse("fn zero ():Int { 0 }") }
      it { expect(parser.named_function).to parse("fn zero ( ):Int { 0 }") }
      it { expect(parser.named_function).to parse("fn zero ( ) :Int { 0 }") }
      it { expect(parser.named_function).to parse("fn zero ( ) : Int { 0 }") }
      it { expect(parser.named_function).to parse("fn first(a:Int, b:Int):Int { a }") }
      it { expect(parser.named_function).to parse("fn first(a:User):Int { a }") }
    end
  end
  context 'calling functions' do
    it 'identifies a function being called' do
      expect(parser.call).to parse("ten()")
      expect(parser.call).to parse("first(1, 2)")
    end
  end
  context 'expressions' do
    it 'can take any valid piece of syntax' do
      expect(parser.expression).to parse('a = fn (a:Int, b:Int):Int { "this wont pass the type checker, but will pass" }')
    end
  end
end
