require "test/unit"
require_relative '../src/store/inventory'
class TestInventoryLoad < Test::Unit::TestCase

  def setup
    @inventory = Inventory.instance
  end
  def test_single_load
    @inventory.clear_inventory!
    @inventory.add(name: 'stillmatic',artist: 'nas',year: '2001',format: {name: 'CD',count: 1})
    result = @inventory.search(field: 'name',query: 'stillmatic')
    assert_equal(1, result.size)
    assert_equal('nas', result.first[:artist])
    assert_equal('stillmatic', result.first[:name])
  end

  def test_different_format_load
    @inventory.clear_inventory!
    @inventory.add(name: 'untitled',artist: 'nas',year: '2008',format: {name: 'CD',count: 1})
    @inventory.add(name: 'untitled',artist: 'nas',year: '2008',format: {name: 'VINYL',count: 1})
    result = @inventory.search(field: 'name',query: 'untitled')
    assert_equal(1, result.size)
    assert_equal('nas', result.first[:artist])
    assert_equal('untitled', result.first[:name])
    assert_equal(2,result.first[:formats].size)
  end

  def test_same_format_double_load
    @inventory.clear_inventory!
    @inventory.add(name: 'untitled',artist: 'nas',year: '2008',format: {name: 'CD',count: 1})
    @inventory.add(name: 'untitled',artist: 'nas',year: '2008',format: {name: 'CD',count: 1})
    result = @inventory.search(field: 'name',query: 'untitled')
    assert_equal(1, result.size)
    assert_equal('nas', result.first[:artist])
    assert_equal('untitled', result.first[:name])
    assert_equal(1,result.first[:formats].size)
    assert_equal(2,result.first[:formats].first[:count])
    assert_equal('cd',result.first[:formats].first[:name])
  end

  def test_different_artist_case_load
    @inventory.clear_inventory!
    @inventory.add(name: 'untitled',artist: 'nas',year: '2008',format: {name: 'CD',count: 1})
    @inventory.add(name: 'untitled',artist: 'NAS',year: '2008',format: {name: 'CD',count: 1})
    result = @inventory.search(field: 'name',query: 'untitled')
    assert_equal(1, result.size)
  end
  def test_different_album_case_load
    @inventory.clear_inventory!
    @inventory.add(name: 'untitled',artist: 'nas',year: '2008',format: {name: 'CD',count: 1})
    @inventory.add(name: 'unTITLed',artist: 'NAS',year: '2008',format: {name: 'CD',count: 1})
    result = @inventory.search(field: 'name',query: 'untitled')
    assert_equal(1, result.size)
  end
end
