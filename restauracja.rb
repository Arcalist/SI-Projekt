require 'rgl/adjacency'
require 'rgl/dot'
require 'rgl/dijkstra'
require './kitchen.rb'
require './table.rb'
require './kelner.rb'
require 'decisiontree'

class Restaurant
    attr_accessor :tables, :kitchen, :routes, :graph, :orders, :queue, :dont_check, :receipts
    def initialize
        @turn = 1
        @graph = RGL::AdjacencyGraph.new
        @tables = [Table.new, Table.new, Table.new, Table.new, Table.new, Table.new, Table.new]
        @kitchen = Kitchen.new
        @waiter = Waiter.new(@kitchen, self)
        @orders = Hash.new
        @queue = Hash.new { |h, k| h[k] = [] }
        @dont_check = false
        @receipts = Hash.new(0)
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
        attributes = ['@kitchen', 'queue[menu]', 'queue[food]', 'queue[order]', 'queue[receipt]', 'queue[ready_to_pay]', 'queue[clean]']
        training = [
            #@kitch, menu, food, order, receipt, rtp, clean, result
            ["true", "false", "false", "false", "false", "false", "false", 'menu'],
            ["false", "false", "false", "false", "false", "false", "false", 'menu'],
            ["false", "false", "true", "false", "false", "false", "false", 'menu'],
            ["true", "false", "true", "true", "true", "true", "true", 'menu'],
            ["false", 'false', 'true', 'false', 'true', 'true', 'true', 'menu'],
            #["false", "false", "false", "true", "true", "false", "false", 'menu'],
            
            ["false", "true", "false", "false", "false", "false", "false", 'order'],
            ["true", "true", "true", "false", "false", "false", "false", "order"],
            ["false", "true", "true", "false", "true", "true", "true", "order"],
            ["true", "true", "true", "false", "true", "true", "true", "order"],
            ["false", "true", "true", "false", "false", "true", "true", "order"],
            #["false", "true", "true", "false", "false", "true", "true", "order"],
            #["false", "true", "true", "false", "false", "false", "false", "order"],
          
            ["false", "true", "false", "false", "false", "false", "false", "food"],
            ["true", "true", "false", "false", "false", "false", "false", "food"],
            #["true", "false", "false", "true", "true", "true", "true", "food"],
            ["true", "true", "false", "true", "true", "true", "true", "food"],
            ["false", "true", "false", "true", "true", "true", "true", "food"],
            #["true", "false", "false", "false", "true", "false", "true", "food"],
            #["true", "false", "false", "true", "false", "false", "true", "food"],
              
            ["false", "true", "true", "true", "false", "false", "false", 'receipt'],
            ["true", "true", "true", "true", "false", "false", "false", "receipt"],
            ["false", "true", "true", "true", "false", "true", "true", "receipt"],
            ["true", "true", "true", "true", "false", "true", "true", "receipt"],
          
            ["false", "true", "true", "true", "true", "false", "false", 'rtp'],
            ["true", "true", "true", "true", "true", "false", "false", "rtp"],
            ["false", "true", "true", "true", "true", "false", "true", "rtp"],
            ["true", "true", "true", "true", "true", "false", "true", "rtp"],
          
            ["false", "true", "true", "true", "true", "true", "false", 'clean'],
            ["true", "true", "true", "true", "true", "true", "false", "clean"],
          
            ["false", "true", "true", "true", "true", "true", "true", 'return'],
            ["true", "true", "true", "true", "true", "true", "true", "return"]
          
          ]
        @dec_tree = DecisionTree::ID3Tree.new(attributes, training, 1, :discrete)
        @dec_tree.train


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
            if x.empty? and x.clean?
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
        @turn += 1
    end

    def assert_situation
        @tables.each do |x|
            puts x.to_s + ' ' + x.stage
            if x.stage == 'menu'
                unless @queue['menu'].include? x
                    @queue['menu'] << x
                end
            else
                if x.ready
                    unless @queue[x.stage].include? x
                        @queue[x.stage] << x
                    end
                end
            end
            if x.stage == "left"
                unless @queue['clean'].include? x
                    @queue['clean'] << x
                end
            end
        end

        @orders.keys.each do |x|
            if !dont_check
                if kitchen.order_ready? @orders[x]
                    unless @queue['food'].include? @tables[x]
                        @queue['food'] << @tables[x]
                        @dont_check = true
                    end
                end
            end
        end
    end

    def determine_action
        if @waiter.route.empty? and !@waiter.action.empty?
            return @waiter.exe_action
        end
        if !@waiter.action.empty?
            return nil
        end
        @action = "NOT WORKING"
        @situation = [@waiter.at_kitchen?.to_s, @queue['menu'].empty?.to_s, @queue['food'].empty?.to_s, @queue['order'].empty?.to_s, @queue['receipt'].empty?.to_s, @queue['ready to pay'].empty?.to_s, @queue['clean'].empty?.to_s]
        @action = @dec_tree.predict(@situation)
        case @action
        when 'food'
            return @waiter.prepare_to_deliver_food @queue["food"].shift
        when 'menu'
            return @waiter.prepare_to_menu @queue["menu"].shift
        when 'order'
            return @waiter.prepare_to_take_order @queue["order"].shift
        when 'receipt'
            return @waiter.prepare_to_receipt @queue["receipt"].shift
        when 'rtp'
            return @waiter.prepare_to_take_payment @queue["ready to pay"].shift
        when 'clean'
            return @waiter.prepare_to_clean @queue["clean"].shift
        when 'return'
            return @waiter.return_to_kitchen
        else
            return nil
        end
    end

end

restaurant = Restaurant.new
#restaurant.routes[restaurant.kitchen].each { |x| puts x.join(', ')}

while true do
    restaurant.pass_time
    #gets.chomp()
    sleep(1)
end
