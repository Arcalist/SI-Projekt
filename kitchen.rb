require './menu.rb'

class Kitchen
    def initialize
        @order_queue = []
        @ready = []
    end

    def prepare
        @order_queue.each do |d| 
            d.preparation_time -= 1
            if d.preparation_time < 0                
                @ready << d.to_s
                @order_queue.delete_at(@order_queue.index(d))
            end
        end
    end 

    def pass_order order
        @order_queue << order
    end

    def to_status
        if @order_queue.empty? and @ready.empty? then return "Pusto" end
        string = ''
        unless @order_queue.empty?
            @order_queue.each do |x|
                string += x.to_status + "\n"
            end
        end
        unless @ready.empty?
            string += 'Gotowe: '
            @ready.each do |x|
                string += x.to_s + "\n"
            end
        end
        string
    end

    def order_ready? x
        hash = Hash.new(0)
        x.each { |d| hash[d] += 1 }
        hash.each do |h, k|
            unless @ready.count(h) >= k 
                return false
            end
        end
        return true 
    end

    def give_out x
        @ready.delete_at(@ready.index(x))
        x
    end
    
    def to_s
        "Kuchnia"
    end
end