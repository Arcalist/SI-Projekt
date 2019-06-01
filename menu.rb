require './danie.rb'

class Menu
    attr_reader :dishes
    def initialize
        @dishes = [
            Dish.new('Kebab', 15, 30),
            Dish.new('Zapiekanka', 10, 20),
            Dish.new('Sałatka', 8, 6),
            Dish.new('Frytki', 6, 20),
            Dish.new('Kanapka', 4, 5),
            Dish.new('Schabowy', 12, 20),
            Dish.new('Lody', 5, 5),
            Dish.new('Ciasto', 7, 5),
            Dish.new('Kawa', 4, 1),
            Dish.new('Herbata', 4, 1)
        ]
    end

    def to_s
        "menu"
    end
end