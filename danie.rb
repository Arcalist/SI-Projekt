class Dish
    attr_accessor :preparation_time, :name, :default_prep, :price
    def initialize name, price, preparation_time
        @name = name
        @price = price
        @preparation_time = preparation_time
        @default_prep = preparation_time
    end

    def to_status
        @name + ': ' + @preparation_time.to_s
    end

    def to_s
        @name
    end

end