module Booleans < Parslet::Parser
  rule(:b_false) { (str('false') >> space?).as(:false) }
  rule(:b_true)  { (str('true')  >> space?).as(:true) }
  rule(:b_and)   { ((str('and')| str('&&')) >> space?).as(:and)}
  rule(:b_not)   { ((str('not')| str('!'))  >> space?).as(:not) }
  rule(:b_or)    { ((str('or') | str('||')) >> space?).as(:or) }
  rule(:boolean) { (b_true | b_false | b_and | b_or | b_not).as(:boolean) }
end
