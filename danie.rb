class Dish
    attr_accessor :preparation_time
    def initialize name, price, preparation_time
        @name = name
        @price = price
        @preparation_time = preparation_time
    end

    def to_s
        @name
    end
end