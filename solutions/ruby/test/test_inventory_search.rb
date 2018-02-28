require "test/unit"
require_relative '../src/store/inventory'
class TestInventorySearch < Test::Unit::TestCase

  def setup
    @inventory = Inventory.instance
    @inventory.clear_inventory!
    @inventory.add(name: 'untitled',artist: 'nas',year: '2008',format: {name: 'CD',count: 1})
    @inventory.add(name: 'untitled',artist: 'nas',year: '2008',format: {name: 'CD',count: 1})
    @inventory.add(name: 'stillmatic',artist: 'nas',year: '2001',format: {name: 'CD',count: 1})
    @inventory.add(name: 'stillmatic',artist: 'nas',year: '2001',format: {name: 'VINYL',count: 1})
    @inventory.add(name: 'illmatic',artist: 'nas',year: '1994',format: {name: 'CD',count: 1})
    @inventory.add(name: 'illmatic',artist: 'nas',year: '1994',format: {name: 'VINYL',count: 1})
    @inventory.add(name: 'domino',artist: 'domino',year: '1993',format: {name: 'TAPE',count: 1})
    @inventory.add(name: 'domino',artist: 'domino',year: '1993',format: {name: 'TAPE',count: 1})
    @inventory.add(name: 'blueprint',artist: 'jay-z',year: '2001',format: {name: 'CD',count: 1})
  end

  def test_search_by_artist
    result = @inventory.search(field: 'artist',query: 'nas')
    assert_equal(3, result.size)
  end

  def test_search_by_artist_partial
    result = @inventory.search(field: 'artist',query: 'min')
    assert_equal(1, result.size)
  end

  def test_search_by_artist_sorting
    result = @inventory.search(field: 'artist',query: 'nas')
    assert_equal(3, result.size)
    assert_equal('illmatic', result[0][:name])
    assert_equal('stillmatic', result[1][:name])
    assert_equal('untitled', result[2][:name])
  end

  def test_search_by_name
    result = @inventory.search(field: 'name',query: 'stillmatic')
    assert_equal(1, result.size)
  end

  def test_search_by_name_partial
    result = @inventory.search(field: 'name',query: 'matic')
    assert_equal(2, result.size)
  end

  def test_search_by_name_sorting
    result = @inventory.search(field: 'name',query: 'matic')
    assert_equal('illmatic', result[0][:name])
    assert_equal('stillmatic', result[1][:name])
  end

  def test_search_by_year
    result = @inventory.search(field: 'year',query: '2001')
    assert_equal(2, result.size)
  end

  def test_search_by_year_partial
    result = @inventory.search(field: 'year',query: '200')
    assert_equal(0, result.size)
  end

  def test_search_by_year_sorting
    result = @inventory.search(field: 'year',query: '2001')
    assert_equal(2, result.size)
    assert_equal('blueprint', result[0][:name])
    assert_equal('stillmatic', result[1][:name])
  end
end
