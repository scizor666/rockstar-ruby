require 'test_helper'

class ConditionsTest < Minitest::Spec

  it 'tests "if" transformation' do
    tree = Rockstar.parse("If lucy is as strong as my world\nEveryone is doomed")
    assert_equal "if(((lucy).to_f>=(my_world).to_f));everyone=6;end", Rockstar.transform(tree)
  end

  it 'tests "if-else" transformation' do
    tree = Rockstar.parse("If lucy is as strong as my world\nEveryone is doomed\n\nElse\nEveryone is gonna be fine")
    assert_equal "if(((lucy).to_f>=(my_world).to_f));everyone=6;else;everyone=524;end", Rockstar.transform(tree)
  end
end
