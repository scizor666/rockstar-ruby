require 'test_helper'

class FunctionsTest < Minitest::Spec
  let(:midnight_def) do
    @midnight_def = %{Midnight takes your heart and your soul
While your heart is as high as your soul
Your Heart is your heart without your soul

Give back your heart}
  end

  let(:midnight_def_ruby) do
    @midnight_def_ruby = %{def midnight(your_heart,your_soul);\
while((your_heart).to_f>=(your_soul).to_f);\
your_heart=your_heart.to_f-your_soul.to_f;\
end;\
return your_heart;\
end}
  end

  let(:midnight_call) do
    @midnight_call = 'Midnight taking your heart, your soul'
  end

  let(:midnight_call_ruby) do
    @midnight_call_ruby = 'midnight(your_heart,your_soul)'
  end

  it 'tests function with internal loop definition' do
    assert_equal midnight_def_ruby, Rockstar.transpile(midnight_def)
  end

  it 'tests function call on block level' do
    assert_equal midnight_call_ruby, Rockstar.transpile(midnight_call)
  end

  it 'tests function definition and subsequent call' do
    assert_equal midnight_def_ruby + ';' + midnight_call_ruby, Rockstar.transpile(midnight_def + "\n\n" + midnight_call)
  end

  it 'tests function call in condition ' do
    assert_equal "if(#{midnight_call_ruby});everyone=6;end", Rockstar.transpile("If #{midnight_call}\nEveryone is doomed")
  end
end