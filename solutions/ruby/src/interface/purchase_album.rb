require './store/inventory'

inventory = Inventory.instance
begin
  result = inventory.purchase(ARGV[0].strip)
  puts "Removed 1 #{result[:format][:name]} of #{result[:name]} by #{result[:artist]} from inventory"
rescue ArgumentError => e
  puts e
end


