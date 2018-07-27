require 'test_helper'

class IntegrationTest < Minitest::Spec
  it 'tests assignments + conditionals + loop' do
    tree = Rockstar.parse %{My World is nothing
Last Night is right
Pity World says its prays
Lucy was a demon
It is my world without lucy
It is my world with lucy
It is my world of lucy
It is my world by lucy
Me is the one

If lucy is as strong as my world
Everyone is doomed

Else
Everyone is gonna be fine

If lucy without me is stronger than lucy with me
Everything is gonna be alright

Desire is a lovestruck ladykiller
My World is nothing
Fire is ice
Hate is water
Until my world is desire
Build my world up}
    ruby_expected = "my_world=nil;last_night=true;pity_world='its prays';\
lucy=15;it=my_world.to_f-lucy.to_f;it=my_world.to_f+lucy.to_f;it=my_world.to_f*lucy.to_f;it=my_world.to_f/lucy.to_f;me=33;\
if((lucy).to_f>=(my_world).to_f);everyone=6;else;everyone=524;end;\
if((lucy.to_f-me.to_f).to_f>(lucy.to_f+me.to_f).to_f);everything=527;end;\
desire=100;my_world=nil;fire=3;hate=5;until((my_world).to_f==(desire).to_f);my_world=my_world.to_f+1;end;"
    assert_equal ruby_expected, Rockstar.transform(tree)
  end
end