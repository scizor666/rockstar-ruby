require 'test_helper'

class FunctionsTest < Minitest::Spec
  it 'tests function with internal loop definition' do
    tree = Rockstar.parse %{Midnight takes your heart and your soul
While your heart is as high as your soul
Your Heart is your heart without your soul

Give back your heart}

    ruby_expected = "def midnight(your_heart,your_soul);\
while((your_heart).to_f>=(your_soul).to_f);\
your_heart=your_heart.to_f-your_soul.to_f;\
end;\
return your_heart;\
end;"
    assert_equal ruby_expected, Rockstar.transform(tree)
  end
end