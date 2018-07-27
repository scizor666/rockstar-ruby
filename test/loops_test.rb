require 'test_helper'

class LoopsTest < Minitest::Spec
  it 'tests until loop' do
    tree = Rockstar.parse %{Desire is a lovestruck ladykiller
My World is nothing
Fire is ice
Hate is water
Until my world is desire
Build my world up}
    assert_equal "desire=100;my_world=nil;fire=3;hate=5;until((my_world).to_f==(desire).to_f);my_world=my_world.to_f+1;end;", Rockstar.transform(tree)
  end

  it 'tests while loop' do
    tree = Rockstar.parse "While my world is not desire\nKnock my world down"
    assert_equal "while((my_world).to_f!=(desire).to_f);my_world=my_world.to_f-1;end;", Rockstar.transform(tree)
  end
end