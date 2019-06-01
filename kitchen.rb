require './menu.rb'

class Kitchen
    def initialize
        @order_queue = []
    end

    def prepare
        @order_queue.each { |d| d.preparation_time -= 1}
    end 

    def pass_order order
        order = order.pass
        order.each do |x|
            @order_queue << x
        end
    end

    def to_status
        if @order_queue.empty? then return "Pusto" end
        string = ''
        @order_queue.each do |x|
            string += x.to_status + "\n"
        end
        string
    end

    def to_s
        "Kuchnia"
    end
end