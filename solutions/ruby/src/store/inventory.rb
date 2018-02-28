require 'yaml'
require 'singleton'
require_relative 'album'

class Inventory
  include Singleton
  STORAGE_PATH = '../data/inventory.yml'

  def initialize
    data = YAML.load_file(STORAGE_PATH) 
    if data
      @albums = data.collect{|d| Album.new(d)}
    else
      @albums = []
    end
    ObjectSpace.define_finalizer( self, self.class.finalize(@albums) )
  end
  
  def search(args)
    if ['artist','name','uuids','format_types'].include?(args[:field])
      result = @albums.collect{|album| album.to_hash if album.send(args[:field]).include?(args[:query].downcase)}.compact
    elsif ['year'].include?(args[:field])
      result = @albums.collect{|album| album.to_hash if album.send(args[:field]).downcase == (args[:query])}.compact
    end
    return sort_search_results(result,args[:field])
  end


  #interface for purchasing album
  def purchase(uuid)
    album = @albums.detect{|album| album.uuids.include?(uuid)}
    raise ArgumentError.new("Unknown Album") if album.nil?
    format  = album.remove(uuid: uuid,count: 1)
    if album.formats.empty?
      @albums.delete(album)
    end
    return {name: album.name,artist:album.artist,:format=>{name: format.name,uuid: format.uuid}}
  end

  #adds new album to inventory
  def add(params)
    new_album = Album.new(params)
    album = @albums.detect{|a| a == new_album}
    if album.nil?
      album = new_album
      @albums << album
    end
    album.add(params[:format])
  end

  #wipes entire inventory
  #use with caution
  def clear_inventory!
    @albums=[]
  end

  #writes inventory to file
  def self.finalize(albums)
    proc {
    File.open(STORAGE_PATH, 'w') {|f| f.write albums.collect{|album| album.to_hash}.to_yaml }}
  end

  private
  #helper method to sort results
  def sort_search_results(results,field)
    if ['artist','name'].include?(field)
      results.sort_by!{|h| [ h[field.to_sym],h[(['artist','name'] - [field]).first.to_sym]]}
    else
      results.sort_by!{|h| [ h[:artist],h[:name] ]}
    end
  end

end
