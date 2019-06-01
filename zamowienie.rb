class Order
    def initialize
        @order = []
    end

    def add x
        @order << x
    end

    def pass
        @order
    end

    def to_s
        @order.join(', ')
    end
end