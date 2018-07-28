module Rockstar
  class RockstarTransformer < Parslet::Transform
    # types
    rule(:true => simple(:_)) {'true'}
    rule(:false => simple(:_)) {'false'}
    rule(:nil => simple(:_)) {'nil'}
    rule(:str => simple(:str)) {"'#{str.to_s.gsub("'", "\\'")}'"}
    rule(:number_str => simple(:str)) {str.to_s.split(/\s+/).map {|e| e.length % 10}.join.to_i}

    # math
    rule(:- => simple(:_)) {'-'}
    rule(:+ => simple(:_)) {'+'}
    rule(:* => simple(:_)) {'*'}
    rule(:/ => simple(:_)) {'/'}
    rule(:l_op => simple(:left), :op => simple(:operation), :r_op => simple(:right)) do |context|
      "#{to_snake_case(context[:left])}.to_f#{context[:operation]}#{to_snake_case(context[:right])}.to_f"
    end

    # assignment
    rule(:var => {:var_name => simple(:name), :var_value => simple(:value)}) do |context|
      "#{to_snake_case(context[:name])}=#{context[:value]}"
    end

    # comparison
    rule(:> => simple(:_)) {'>'}
    rule(:< => simple(:_)) {'<'}
    rule(:>= => simple(:_)) {'>='}
    rule(:<= => simple(:_)) {'<='}
    rule(:== => simple(:_)) {'=='}
    rule(:!= => simple(:_)) {'!='}
    rule(:l_op => simple(:left), :comparison_op => simple(:operation), :r_op => simple(:right)) do |context|
      "((#{to_snake_case(context[:left])}).to_f#{context[:operation]}(#{to_snake_case(context[:right])}).to_f)"
    end
    rule(:comparison => simple(:comparison), :block => simple(:block)) {"#{comparison};#{block}"}
    rule(:comparison_expression => simple(:comparison_exp), :block => simple(:block)) {"(#{comparison_exp});#{block}"}

    # conditionals
    rule(:if_block => simple(:if_blk), :else_block => simple(:else_blk)) {"if#{if_blk};else;#{else_blk};end"}
    rule(:if_block => simple(:if_blk)) {"if#{if_blk};end"}

    # loops
    rule(:increment => simple(:increment)) do |context|
      var_name = to_snake_case(context[:increment])
      "#{var_name}=#{var_name}.to_f+1"
    end
    rule(:decrement => simple(:decrement)) do |context|
      var_name = to_snake_case(context[:decrement])
      "#{var_name}=#{var_name}.to_f-1"
    end
    rule(:comparison => simple(:comparison)) {"#{comparison}"}
    rule(:until_block => simple(:block)) {"until#{block};end"}
    rule(:while_block => simple(:block)) {"while#{block};end"}

    # function definitions
    rule(:function_arg => simple(:arg)) { arg }
    rule(:function_name => simple(:name),
         :function_args => sequence(:args),
         :function_body => sequence(:body_parts),
         :function_return => simple(:return)) do |context|
      "def #{to_snake_case(context[:name])}(#{context[:args].map {|arg| to_snake_case(arg)}.join(',')});\
#{context[:body_parts].join(';')};\
return #{to_snake_case(context[:return])};\
end"
    end

    # function calls
    rule(:function_passed_arg => simple(:arg)) {arg}
    rule(:function_name => simple(:name), :function_passed_args => sequence(:args)) do |context|
      "#{to_snake_case(context[:name])}(#{context[:args].map {|arg| to_snake_case(arg)}.join(',')})"
    end

    # general
    rule(:block => simple(:blk)) {blk}
    rule(:block => sequence(:lines)) {lines.join(';')}
    rule(:blocks => sequence(:blocks)) {blocks.join(';')}

    def self.to_snake_case(str)
      str.to_s.downcase.gsub(/\s+/, '_')
    end
  end
end