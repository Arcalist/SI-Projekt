require './menu.rb'
class Waiter
    attr_accessor :action, :holding, :route, :location
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
        move
    end

    def prepare_to_take_order target
        @action = ["take order"]
        @target = target
        @route = @restaurant.pathfind @location, target
        target.stage = "wait for take order"
    end

    def prepare_to_deliver_food target
        @action = ["take food"]
        @target = target
        @route = @restaurant.pathfind @location, @restaurant.kitchen
        target.stage = "almost there"
    end

    def prepare_to_receipt target
        @action = ["take receipt"]
        @target = target
        @route = @restaurant.pathfind @location, @restaurant.kitchen
        target.stage = 'wait for receipt'
    end

    def prepare_to_take_payment target
        @action = ["take money"]
        @target = target
        @route = @restaurant.pathfind @location, target
        target.stage = "wait for change"
    end

    def prepare_to_clean target
        @action = ["cleaning"]
        @target = target
        @route = @restaurant.pathfind @location, target
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
            @restaurant.orders[@target.to_int] = []
            until @holding.empty?
                x = @holding.shift
                @restaurant.kitchen.pass_order x
                @restaurant.orders[@target.to_int] << x.to_s
                @restaurant.receipts[@target.to_int] += x.price
            end
            @action.shift
            @target = ''
            

        elsif @action[0] == "take order"
            x = @target.pass_order
            @holding = x
            @action = ["pass order"]
            @route = @restaurant.pathfind @location, @restaurant.kitchen

        elsif @action[0] == "take food"
            o = @restaurant.orders[@target.to_int]
            o.each { |d| @holding << @restaurant.kitchen.give_out(d) }
            @action = ["deliver food"]
            @route = @restaurant.pathfind @location, @target

        elsif @action[0] == "deliver food"
            @target.clients.each do |c|
                @holding.each do |f|
                    if c.order.to_s == f.to_s and c.status != "eat"
                        c.get_food f
                    end
                end
            end
            @holding = []
            @target.ready = false
            @restaurant.orders.delete(@target.to_int)
            @target.stage = "eating"
            @action = ''
            @target = ''
            @restaurant.dont_check = false

        elsif @action[0] == "take receipt"
            @holding = ["receipt " + @target.to_s]
            @action = ['give receipt']
            @route = @restaurant.pathfind @restaurant.kitchen, @target

        elsif @action[0] == "give receipt"
            @holding = []
            @action = []
            @target.price = @restaurant.receipts[@target.to_int]
            @target.paying
            @target = []

        elsif @action[0] == "take money"
            @holding = ["money"]
            @action = ["take change"]
            @route = @restaurant.pathfind @location, @restaurant.kitchen

        elsif @action[0] == "take change"
            @holding = ["change"]
            @action = ["return change"]
            @route = @restaurant.pathfind @location, @target
            
        elsif @action[0] == "return change"
            @holding = []
            @action = []
            @target.prepare_to_leave
            @target = []

        elsif @action[0] == "cleaning"
            @holding = ["dirty dishes"]
            @action = ["return dishes"]
            @target.default_state
            @route = @restaurant.pathfind @location, @restaurant.kitchen
            @target = []

        elsif @action[0] == "return dishes"
            @holding = []
            @action = []
        end
        nil
        
    end

    def to_s
        @location.to_s + " " + @action.to_s + " " + @target.to_s + " " + @holding.join(', ')
    end
end