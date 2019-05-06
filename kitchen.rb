require './menu.rb'

class Kitchen
    def initialize
        @order_queue = []
    end

    def prepare
        @order_queue.each { |d| d.preparation_time -= 1}
    end 

    def pass_order order
        order.each do |x|
            @order_queue << x
        end
    end

    def to_s
        "Kitchen"
    end
end