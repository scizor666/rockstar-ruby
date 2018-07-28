require 'test_helper'

class AssignmentsTest < Minitest::Spec

  it 'tests nil assignment' do
    tree = Rockstar.parse("My World is nothing")
    assert_equal 'my_world=nil', Rockstar.transform(tree)
  end

  it 'tests true assignment' do
    tree = Rockstar.parse("Last Night is right")
    assert_equal 'last_night=true', Rockstar.transform(tree)
  end

  it 'tests false assignment' do
    tree = Rockstar.parse("All is wrong")
    assert_equal 'all=false', Rockstar.transform(tree)
  end
end
