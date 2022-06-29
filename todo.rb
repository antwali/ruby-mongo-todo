=begin
Build a simple CLI application for managing a to-do list with Ruby and MongoDB. Support these commands:

*todo add <item> to create an entry in the to-do list

*todo list to show all items in the to-do list

*todo remove <item> to remove an item from the to-do list

MongoDB object ids are not very user-friendly, so it may be a good idea to number to-do list items for easier identification.
=end

require "mongo"
class MongoDbConnection
    class << self
        def tasks_collection
            client[:tasks]
        end
        
        def configs_collection
            client[:configs]
        end

        def client
            return @client if defined? (@client)

            @client = Mongo::Client.new([ '127.0.0.1:27017' ], database: 'todo') #Connects to the database connection
        end

        def help()
            puts "Choose Option\nadd or show or remove" #Prompts user to choose option between the 3 options
        end

        def add (task_name)
            count= configs_collection.find({key:"last_id"}).first["value"]
            count = count + 1
            tasks_collection.insert_one({ name: task_name, task_id: count})
            configs_collection.update_one({key: "last_id"},{'$set':{value:count}})
        end
        
        def show()
            found= tasks_collection.find()
            found.each {|x| puts "#{x["name"]} (#{x["task_id"]})" }
        end

        def remove(task_name)
            tasks_collection.delete_one({ task_id: task_name.to_i})
        end
        
        def removeMany(first, second)
            tasks_collection.delete_many({ task_id: {"$in":[first.to_i, second.to_i]}})
        end

    end 
end



choice = ARGV[0]
case choice
when 'help'
    help()
when 'add'
    MongoDbConnection.add(ARGV[1])
when 'show'
    MongoDbConnection.show()
when 'remove'
    MongoDbConnection.remove(ARGV[1])
when 'removeMany'
     MongoDbConnection.removeMany(ARGV[1], ARGV[2])
else
    puts "You can only choose 'help', 'add', 'show' or 'remove'"
end


##largest_id = collection.find().sort({task_id:-1}).limit(1) || 0

# client[:tasks].insert_one({ name: ARGV[1]}
