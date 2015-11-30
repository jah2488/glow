class GLParser < Parslet::Parser
  rule(:space)  { match('\s').repeat(1) }
  rule(:space?) { space.maybe }

  rule(:number) { match('\d').repeat(1).as(:number) >> space? }
  rule(:string) { (str('"') >> match('[^"]').repeat(0) >> str('"')).as(:string) >> space? }

  rule(:b_false) { (str('false') >> space?).as(:false) }
  rule(:b_true)  { (str('true')  >> space?).as(:true) }
  rule(:b_and)   { ((str('and')| str('&&')) >> space?).as(:and)}
  rule(:b_not)   { ((str('not')| str('!'))  >> space?).as(:not) }
  rule(:b_or)    { ((str('or') | str('||')) >> space?).as(:or) }
  rule(:boolean) { (b_true | b_false | b_and | b_or | b_not).as(:boolean) }


  literals = {
    lparen: '(',
    rparen: ')',
    lbrace: '{',
    rbrace: '}',
    colon:  ':',
    comma:  ',',
    equals: '='
  }
  literals.each do |name, val|
    rule(name) { str(val) >> space? }
  end

  rule(:fn) { (str('fn') | str('->')) >> space? }

  rule(:identifier) { match('[a-z]').repeat(1) >> space? }
  rule(:constant) { match('[A-Z]') >> match('[a-zA-Z]').repeat(0) >> space? }

  rule(:equals) { str('=') >> space? }
  rule(:assign) { (identifier.as(:target) >> equals >> expression.as(:value)).as(:assign) }
  rule(:variable) { identifier.as(:variable) }


  rule(:function) do
    (fn >> params >> colon >> constant.as(:return_type) >> body).as(:function)
  end
  rule(:named_function) do
    (fn >> identifier.as(:name).maybe >> params >> colon >> constant.as(:return_type) >> body).as(:named_function)
  end

  rule(:params) do
    lparen >> (param.maybe >> (comma >> param).repeat(0)).as(:params) >> rparen
  end
  rule(:param) { (identifier.as(:param) >> space? >> colon >> constant.as(:type)) >> space? }

  rule(:body) { lbrace >> expressions.as(:body) >> rbrace }

  rule(:call) { (identifier.as(:target) >> args).as(:call) }

  rule(:args) { lparen >> (arg.maybe >> (comma >> arg).repeat(0)).as(:args) >> rparen }
  rule(:arg)  { expression.as(:arg) }

  rule(:expression)  { (boolean | assign | function | named_function | call | string | number | variable) >> space? }
  rule(:expressions) { space? >> expression.repeat(1) }

  root(:expressions)
end
