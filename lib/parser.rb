class GLParser < Parslet::Parser
  rule(:space)  { match('\s').repeat(1) }
  rule(:space?) { space.maybe }

  rule(:number) { match('\d').repeat(1).as(:number) >> space? }
  rule(:string) { (str('"') >> match('[^"]').repeat(0) >> str('"')).as(:string) >> space? }

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

  rule(:expression)  { (assign | function | named_function | call | string | number | variable) >> space? }
  rule(:expressions) { space? >> expression.repeat(1) }

  root(:expressions)
end
