=begin
Build a simple CLI application for managing a to-do list with Ruby and MongoDB. Support these commands:

*todo add <item> to create an entry in the to-do list

*todo list to show all items in the to-do list

*todo remove <item> to remove an item from the to-do list

MongoDB object ids are not very user-friendly, so it may be a good idea to number to-do list items for easier identification.
=end

require "mongo"

#Connects to the database
client = Mongo::Client.new([ '127.0.0.1:27017' ], database: 'todo')

choice = ARGV[0]
case choice
when 'help'
    puts "Choose Option\nadd or show or remove" #Prompts user to choose option between the 3 options
when 'add'

count = client[:configs].find({key:"last_id"}).first["value"]
count= count + 1
client[:tasks].insert_one({ name: ARGV[1], task_id: count}) #add fx

client[:configs].update_one({key: "last_id"},{'$set':{value:count}})

when 'show'
    found= client[:tasks].find()
    found.each {|x| puts "#{x["name"]} (#{x["task_id"]})" }#shows all documemnts in the collection

when 'remove'
    client[:tasks].delete_one({ task_id: ARGV[1].to_i}) #remove One

# when 'removeAll'
#     client[:tasks].delete_many({ name: ARGV[1]}) #remove All

else
    puts "You can only choose 'help', 'add', 'show' or 'remove'"
end


##largest_id = collection.find().sort({task_id:-1}).limit(1) || 0

## New config collection


# client[:tasks].insert_one({ name: ARGV[1]}
# puts count