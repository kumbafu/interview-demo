require 'yaml'
require 'SecureRandom'
require_relative 'format'
class Album
  @@inventory = []#YAML.load("./inventory.yml")

  attr_accessor :name,:artist,:year,:formats
  alias_method :eql?, :==

  def initialize(args)
    self.artist = args[:artist].downcase
    self.name = args[:name].downcase
    self.year = args[:year]
    self.formats = []
    if args[:formats]
      args[:formats].each do |format|
        self.formats << Format.new(format)
      end
    end
  end

  #helper_method to view all uuid for this album
  def uuids
    formats.collect{|format| format.uuid}
  end

  #helper method to view all format types for this album
  def format_types
    formats.collect{|format| format.name}
  end

  #decreases the count of a corresponding format
  #for this album and removes the the format if 
  #count is below zero
  def remove(uuid:,count:)
    format = formats.detect{|format| format.uuid==uuid}
    format.count -= count
    formats.delete(format) if format.count <= 0
    return format
  end

  #adds to the count of a given format
  def add(args)
    format = formats.detect{|format| format.name.downcase==args[:name].downcase}
    if format.nil?
      format = Format.new(args)
      formats << format
    else
      format.count += args[:count].to_i || 1
    end
  end

  def ==(o)
    o.name.downcase == self.name.downcase && o.artist.downcase ==  self.artist.downcase && o.year == self.year
  end

  def to_hash
    {artist: artist,
     name: name,
     year:  year,
     formats: self.formats.collect{|format| format.to_hash}
    }
  end
  def to_yaml
    to_hash.to_yaml
  end
end
