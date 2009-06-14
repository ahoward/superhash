#!/usr/bin/env ruby

require 'test/unit'
require 'superhash'

class Test_SuperHash < Test::Unit::TestCase

  def setup
    ## should have an assortment of possibilties
    p0 = { 1=>2, 2=>3, 3=>4 }
    p1 = { 1=>3, 2=>4, 3=>5, 4=>6 }
    
    @inherited = p1.dup.update(p0)
    
    @sh = SuperHash.new [p0, p1], :zip
    
    @own = { 0=>0, 1=>1 }
    @sh.own.update @own
    
    @expected = p1.dup.update(p0.dup.update(@own))
    
    @missing =  "foo"   # just an example of a missing key
  end
  alias set_up setup # just for earlier versions of Test::Unit
  
  def test_inherits_key
    assert(@sh.inherits_key?(2))
    assert(@sh.inherits_key?(4))
    assert(! @sh.inherits_key?(0))
    assert(! @sh.inherits_key?(1))
  end
  
  def test_to_h
    assert_equal(@expected, @sh.to_hash)
  end
  
  def test_each
    @sh.each { |k, v|
      @expected.delete(k) {
        flunk("Unexpected key #{k} found in superhash.")
      }
    }
    assert(@expected.empty?,
      "Keys #{@expected.keys.inspect} were not traversed during each.")
  end
  
  def test_fetch
    assert_raises IndexError do
      @sh.fetch @missing
    end
    assert_equal(:worked, @sh.fetch(@missing) {:worked})
    assert_equal(:worked, @sh.fetch(@missing, :worked))
  end
  
  def test_has_value?
    assert(@sh.has_value?(0))
    assert(@sh.has_value?(6))
    assert(!@sh.has_value?(5))
  end
  
  def test_index
    assert_equal(1, @sh.index(1))
    assert_equal(2, @sh.index(3))
  end
  
  def test_invert
    assert_equal(@expected.invert, @sh.invert)
  end
  
  def test_has_key?
    assert(@sh.has_key?(1))
    assert(@sh.has_key?(4))
    assert(!@sh.has_key?(7))
  end
  
  def test_keys
    assert_equal(@expected.keys, @sh.keys)
  end
  
  def test_size
    assert_equal(@expected.size, @sh.size)
  end
  
  def test_store
    @sh[4] = 40
    @expected[4] = 40
    assert_equal(@expected, @sh.to_hash)
  end
  
  def test_clear
    @sh.clear
    assert_equal(:zip, @sh[0])
    assert_equal(:zip, @sh[2])
    assert_equal(:zip, @sh[4])
  end
  
  def test_delete
    assert_equal(6, @sh.delete(4))
    assert_equal(@missing, @sh.delete(@missing) { |k| k })

    assert_equal(0, @sh.delete(0))
    assert_raises IndexError do
      @sh.fetch 0
    end
  end
  
#  def test_delete_if
#    
#  end
#  
#  def test_reject!
#  
#  end
    
  def test_update
    h = {2=>20, 30=>300}
    assert_equal(@expected.update(h), @sh.update(h).to_hash)
  end
  
  def test_values
    assert_equal(@expected.values, @sh.values)
  end

end
