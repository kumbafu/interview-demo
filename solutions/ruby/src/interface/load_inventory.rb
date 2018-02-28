require 'csv'
require './lib/seperator_sniffer'
require './store/inventory'

#sanitizes and appropriately formats input
def sanitize_input_row(row)
  row.each do |k,v|
    v.strip! unless v.nil?
  end
  row_hash = row.to_hash
  row_hash[:format] = {name: row_hash[:format].downcase,count: row_hash[:count] || 1}
  return row_hash
end

#method to check the sanity of the data being entered
def validate_input(data)
  data.each do |row|
    if row[:format].nil? || row[:year].nil? || row[:artist].nil? || row[:name].nil?
      raise ArgumentError.new("Missing Input Field #{row.to_s}")
    end
    if row[:format].empty? || row[:year].empty? || row[:artist].empty? || row[:name].empty?
      raise ArgumentError.new("Missing Input Field #{row.to_s}")
    end
    unless row[:year].size.eql?(4) and row[:year] =~ /\A\d+\z/
      raise ArgumentError.new("Invalid Album Year: #{row.to_s}")
    end
    unless ['vinyl','cd','tape'].include?(row[:format][:name].downcase)
      raise ArgumentError.new("Invalid Album Format: #{row.to_s}")
    end
  end
end

#load file
file_name = ARGV[0]
#detect file type: pipe-delimited or comma seperated
begin
  delimiter =  ColSepSniffer.new(path: file_name).find
rescue Errno::ENOENT
  puts "File Not Found"
  exit
rescue ArgumentError => e
  puts e
  exit
end
#hash to accomodate different header orders of types
headers = {'|'=>['count','format','year', 'artist', 'name'],','=>['artist','name','format','year']}
@input_data=[]
#read file and sanitize data
CSV.parse(open(file_name).read,col_sep: delimiter,headers: headers[delimiter],:header_converters => :symbol) do |row|
  sanitized_row = sanitize_input_row(row).to_hash
  
  @input_data << sanitized_row
end
begin
  validate_input(@input_data)
rescue ArgumentError => e
  puts e
  exit
end

#get store inventory instance
inventory = Inventory.instance

#add inventory
@input_data.each do |row|
  inventory.add(row)
end
