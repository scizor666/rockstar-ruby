class RockstarParser < Parslet::Parser

  root(:blocks)

  # general
  rule(:blocks) {(conditional_block | block).repeat(1).as(:blocks)}
  rule(:eol) {match['\n']}
  rule(:eof) {any.absent?}
  rule(:space) {match('[ \t]').repeat(1)}
  rule(:block) {(block_part >> (eol >> block_part).repeat >> (eol.repeat(2) | eof)).as(:block)}
  rule(:block_part) {loop_block | increment | decrement | loop_continue | loop_break | poetic_literal}

  # types
  rule(:poetic_literal) {(poetic_string_literal | poetic_type_literal | poetic_number_literal).as(:var)}
  rule(:poetic_string_literal) {proper_variable.as(:var_name) >> space >> str('says') >> space >> string_literal.as(:var_value)}
  rule(:poetic_type_literal) {proper_variable.as(:var_name) >> space >> to_be >> type_literal.as(:var_value)}
  rule(:poetic_number_literal) {proper_variable.as(:var_name) >> space >> to_be >> (math_expression | number_literal).as(:var_value)}

  rule(:type_literal) {null_type_literal.as(:nil) | true_type_literal.as(:true) | false_type_literal.as(:false)}
  rule(:true_type_literal) {str('true') | str('right') | str('yes') | str('ok')}
  rule(:false_type_literal) {str('false') | str('wrong') | str('no') | str('lies')}
  rule(:null_type_literal) {str('null') | str('nothing') | str('nowhere') | str('nobody')}

  rule(:string_literal) {match("[^\n]").repeat(1).as(:str)}
  rule(:number_literal) {(unique_variable_name >> (space >> unique_variable_name).repeat).as(:number_str)}

  rule(:proper_variable) {match('[A-Z]') >> match('[a-z]').repeat >> (space >> proper_variable).repeat}
  rule(:common_variable) {str('a') | str('an') | str('the') | str('my') | str('your')}
  rule(:unique_variable_name) {(keyword.absent? >> match('[a-z]')).repeat(1) >> (space >> unique_variable_name).repeat}

  rule(:to_be) {(str('is') | str('was') | str('were')) >> space}
  rule(:keyword) {math_operation | comparison_operation | str('up') | str('down') | str('and')}

  # math
  rule(:plus) {(str('plus') | str('with')).as(:+)}
  rule(:minus) {(str('minus') | str('without')).as(:-)}
  rule(:multiply) {(str('times') | str('of')).as(:*)}
  rule(:divide) {(str('over') | str('by')).as(:/)}
  rule(:math_operation) {(minus | plus | multiply | divide).as(:op)}
  rule(:math_expression) {unique_variable_name.as(:l_op) >> space >> math_operation >> space >> unique_variable_name.as(:r_op)}

  # comparison
  rule(:comparison_operand) {math_expression | unique_variable_name}
  rule(:comparison) {(comparison_operand.as(:l_op) >> space >> comparison_operation >> space >> comparison_operand.as(:r_op)).as(:comparison)}
  rule(:comparison_operation) {(greater.as(:>) | less.as(:<) | greater_or_equal.as(:>=) | less_or_equal.as(:<=) | not_equal.as(:!=) | equal.as(:==)).as(:comparison_op)}
  rule(:greater) {equal >> space >> (str('higher') | str('greater') | str('bigger') | str('stronger')) >> space >> str('than')}
  rule(:less) {equal >> space >> (str('lower') | str('less') | str('smaller') | str('weaker')) >> space >> str('than')}
  rule(:greater_or_equal) {equal >> space >> str('as') >> space >> (str('high') | str('great') | str('big') | str('strong')) >> space >> str('as')}
  rule(:less_or_equal) {equal >> space >> str('as') >> space >> (str('low') | str('little') | str('small') | str('weak')) >> space >> str('as')}
  rule(:equal) {str('is')}
  rule(:not_equal) {str("ain't") | (equal >> space >> str('not'))}

  # conditionals
  rule(:conditional_block) {(if_else_block | if_block.as(:if_block))}
  rule(:if_block) {str('If') >> space >> comparison >> eol >> block}
  rule(:else_block) {str('Else') >> space.maybe >> eol >> block}
  rule(:if_else_block) {if_block.as(:if_block) >> else_block.as(:else_block)}

  # loops
  rule(:loop_block) {until_block.as(:until_block) | while_block.as(:while_block)}
  rule(:until_block) {str('Until') >> space >> comparison >> eol >> block}
  rule(:while_block) {str('While') >> space >> comparison >> eol >> block}
  rule(:loop_break) {str('Break') | str('Break it down')}
  rule(:loop_continue) {str('Continue') | str('Take it to the top')}
  rule(:increment) {str('Build') >> space >> unique_variable_name.as(:increment) >> space >> str('up')}
  rule(:decrement) {str('Knock') >> space >> unique_variable_name.as(:decrement) >> space >> str('down')}

  # functions
  rule(:function) do
    proper_variable.as(:function_name) >> space >> str('takes') >> space >>
        function_arg >> (space >> str('and') >> space >> function_arg).repeat >>
        function_body.as(:function_body) >> function_return.as(:function_return)
  end
  rule(:function_arg) {unique_variable_name.as(:function_arg)}
  rule(:function_body) {(conditional_block | loop_block | (block_part >> eol)).repeat(1)}
  rule(:function_return) {str('Give back') >> space >> unique_variable_name >> (eol.repeat(2) | eof)}
end