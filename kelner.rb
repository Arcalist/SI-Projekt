require './menu.rb'
class Waiter
    attr_accessor :action, :holding, :route
    @@id = 1
    def initialize location, restaurant
        @id = @@id
        @@id += 1
        @location = location
        @restaurant = restaurant
        @holding = []
        @route = []
        @target = ''
        @action = []
    end

    def pass_order k
        k.pass_order order
    end

    def move
        unless @route.empty? or @route == nil
            @location = @route.shift
        end
    end

    def prepare_to_menu target
        @action = ["take menu", "give menu"]
        @target = target
        target.stage = "wait for menu"
        @route = @restaurant.pathfind @location, @restaurant.kitchen
    end
    
    def return_to_kitchen
        @route = @restaurant.pathfind @location, @restaurant.kitchen
    end

    def prepare_to_take_order target
        @action = ["take order"]
        @target = target
        @route = @restaurant.pathfind @location, target
        puts @location
        puts @target
        puts @route
        gets.chomp()
        target.stage = "wait for take order"
    end

    def exe_action
        
        if @action[0] == "take menu"
            @target.to_i.downto(1) { |x| @holding << Menu.new }
            @route = @restaurant.pathfind @location, @target 
            @action.shift

        elsif @action[0] == "give menu"
            @target.clients.each { |x| x.get_menu @holding.pop } 
            @target.stage = "order"
            @target.ready = false
            @target = ''
            unless @target.empty?
                @route = @restaurant.pathfind @location, @target
            else
                @action.shift
            end

        elsif @action[0] == "pass order"
            until @holding.empty?
                @restaurant.kitchen.pass_order @holding.shift
            end
            @action.shift

        elsif @action[0] == "take order"
            x = @target.pass_order
            o = []
            x.pass.each { |x| o << x.to_s }
            @restaurant.orders[@target] = o
            @holding << x
            @action = ["pass order"]
            @target = ''
            @route = @restaurant.pathfind @location, @restaurant.kitchen        
        end
        nil
    end

    def to_s
        @location.to_s + " " + @action.to_s + " " + @target.to_s + " " + @holding.join(', ')
    end
end