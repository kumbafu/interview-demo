require './store/inventory'

if ARGV[0].nil? || ARGV[1].nil?
  puts 'field and search string required'
  exit
end
 
field_translator = {'artist'=>'artist','album'=>'name','year'=>'year','uid'=>'uuids','format'=>'format_types'}
params = {field: field_translator[ARGV[0].downcase],query: ARGV[1].downcase}
if params[:field].nil? or params[:field].empty?
 puts "invalid field name: #{ARGV[0]}"
 exit
end

inventory = Inventory.instance
results = inventory.search(params)
results.each do |result|
   puts "Artist: #{result[:artist].split.map(&:capitalize).join(' ')}"
   puts "Album: #{result[:name].split.map(&:capitalize).join(' ')}"
   puts "Released: #{result[:year].split.map(&:capitalize).join(' ')}"
   result[:formats].each do |format|
     puts "#{format[:name].capitalize}(#{format[:count]}): #{format[:uuid]}"
   end
   puts "\n"
end
