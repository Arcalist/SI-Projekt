require 'rgl/adjacency'
require 'rgl/dot'
require 'rgl/dijkstra'
require './kitchen.rb'
require './table.rb'
require './kelner.rb'

class Restaurant
    attr_reader :tables, :kitchen, :routes, :graph, :orders
    def initialize
        @turn = 1
        @graph = RGL::AdjacencyGraph.new
        @tables = [Table.new, Table.new, Table.new, Table.new, Table.new, Table.new, Table.new]
        @kitchen = Kitchen.new
        @waiter = Waiter.new(@kitchen, self)
        @orders = Hash.new
        @queue = Hash.new { |h, k| h[k] = [] }
        @edge_weights = 
        {
            [1, 2] => 1,
            [1, 4] => 1,
            [1, @tables[0]] => 2,
            [1, @tables[6]] => 2,
            [1, @kitchen] => 1,
            [@kitchen, 1] => 1,


            [2, 3] => 1,
            [2, @tables[0]] => 2,
            [2, @tables[6]] => 2,
            [2, @tables[5]] => 2,
            [2, @tables[4]] => 2,
            

            [3, 4] => 1,
            [3, @tables[0]] => 2,
            [3, @tables[2]] => 2,
            [3, @tables[3]] => 2,
            [3, @tables[4]] => 2,


            [4, @tables[0]] => 2,
            [4, @tables[1]] => 2,
            [4, @tables[2]] => 2

        }
        @edge_weights.each { |(p1, p2), w| @graph.add_edge(p1, p2) }


    end

    def pathfind start, finish
        @graph.dijkstra_shortest_path(@edge_weights, start, finish)
    end

    def pass_time
        system "clear"
        assert_situation
        determine_action
        @waiter.move
        puts "Tura " + @turn.to_s
        @kitchen.prepare
        @tables.each do |x|
            x.pass_time
            if x.empty? and x.clean
                rng = Random.new
                if rng.rand(1..100) == 5
                    x.new_clients
                end
            end
        end
        puts "Stan kuchni: "
        puts @kitchen.to_status
        puts ''
        puts "Stoliki: "
        @tables.each { |x| puts x.to_status }
        puts ''
        puts "Kelner: "
        puts @waiter
        puts @queue["order"]
        @turn += 1
    end

    def assert_situation
        @tables.each do |x|
            if x.stage == "menu"
                unless @queue["menu"].include? x
                    @queue["menu"] << x
                end
            else
                if x.ready
                    unless @queue[x.stage].include? x
                        @queue[x.stage] << x
                    end
                end
            end
        end
    end

    def determine_action
        if @waiter.route.empty? and !@waiter.action.empty?
            return @waiter.exe_action
        end
        if @waiter.action.include? "give menu"
            return nil
        end
        if @waiter.action.empty? and !@queue["menu"].empty?
            return @waiter.prepare_to_menu @queue["menu"].shift
        end
        if @waiter.action.empty? 
            if !@queue["order"].empty?
                return @waiter.prepare_to_take_order @queue["order"].shift
            end
        end
        unless @waiter.action.empty?
            return nil
        end
        @waiter.return_to_kitchen
    end

end

restaurant = Restaurant.new
#restaurant.routes[restaurant.kitchen].each { |x| puts x.join(', ')}

while true do
    restaurant.pass_time
    #gets.chomp()
    sleep(1)
end
