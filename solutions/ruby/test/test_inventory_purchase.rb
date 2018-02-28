require "test/unit"
require_relative '../src/store/inventory'
class TestInventoryPurchase < Test::Unit::TestCase

  def setup
    @inventory = Inventory.instance
  end
  def test_removal
    @inventory.clear_inventory!
    @inventory.add(name: 'stillmatic',artist: 'nas',year: '2001',format: {name: 'CD',count: 2})
    result = @inventory.search(field: 'name',query: 'stillmatic')
    uuid = result.first[:formats].first[:uuid]
    assert_equal(2, result.first[:formats].first[:count])
    @inventory.purchase(uuid)
    result = @inventory.search(field: 'name',query: 'stillmatic')
    assert_equal(1, result.first[:formats].first[:count])
  end

  def test_removal_of_format_with_no_count
    @inventory.clear_inventory!
    @inventory.add(name: 'stillmatic',artist: 'nas',year: '2001',format: {name: 'cd',count: 2})
    @inventory.add(name: 'stillmatic',artist: 'nas',year: '2001',format: {name: 'vinyl',count: 1})
    result = @inventory.search(field: 'name',query: 'stillmatic')
    vinyl = result.first[:formats].detect{|format| format[:name] == 'vinyl'}
    @inventory.purchase(vinyl[:uuid])
    result = @inventory.search(field: 'name',query: 'stillmatic')
    assert_equal(1, result.first[:formats].size)
  end

  def test_removal_of_album_with_no_formats
    @inventory.clear_inventory!
    @inventory.add(name: 'stillmatic',artist: 'nas',year: '2001',format: {name: 'VINYL',count: 1})
    result = @inventory.search(field: 'name',query: 'stillmatic')
    vinyl = result.first[:formats].detect{|format| format[:name] == 'vinyl'}
    @inventory.purchase(vinyl[:uuid])
    result = @inventory.search(field: 'name',query: 'stillmatic')
    assert_equal(0, result.size)
  end

end
