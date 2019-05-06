require 'rgl/adjacency'
require 'rgl/dot'
require 'rgl/dijkstra'
require './kitchen.rb'
require './table.rb'

class Entrance
    def to_s
        "Entrance"
    end
end

class Restaurant
    attr_reader :tables, :kitchen, :entrance, :graph, :edge_weights
    def initialize
        @graph = RGL::DirectedAdjacencyGraph.new
        @tables = [Table.new, Table.new, Table.new, Table.new]
        @kitchen = Kitchen.new
        @entrance = Entrance.new
        @graph.add_vertices 1,2,3,4,5,6,7,8,9, @kitchen, @entrance, tables
        @edge_weights = 
        {
            [1, 2] => 5,
            [1, 4] => 5,
            [1, 5] => 7,
            [1, tables[0]] => 4,

            [2, 3] => 5,
            [2, 5] => 5,
            [2, 1] => 5,
            [2, 4] => 7,
            [2, 6] => 7,
            [2, tables[0]] => 4,
            [2, tables[1]] => 4,
            [2, kitchen] => 1,
            [kitchen, 2] => 1,

            [3, 2] => 5,
            [3, tables[0]] => 4,
            [3, 6] => 3,
            [3, 5] => 7,

            [4, 1] => 5,
            [4, 5] => 5,
            [4, 7] => 5,
            [4, tables[0]] => 4,
            [4, tables[2]] => 4,
            [4, 2] => 7,
            [4, 8] => 7,

            [5, 1] => 7,
            [5, 2] => 5,
            [5, 3] => 7,
            [5, 4] => 5,
            [5, 6] => 5,
            [5, 7] => 7,
            [5, 8] => 5,
            [5, 9] => 7,
            [5, tables[0]] => 4,
            [5, tables[1]] => 4,
            [5, tables[2]] => 4,
            [5, tables[3]] => 4,

            [6, 2] => 7,
            [6, 3] => 5,
            [6, 5] => 5,
            [6, 8] => 7,
            [6, 9] => 5,
            [6, tables[1]] => 4,
            [6, tables[3]] => 4,
            [6, entrance] => 1,
            [entrance, 6] => 1,

            [7, 4] => 5,
            [7, 5] => 7,
            [7, 8] => 5,
            [7, tables[2]] => 4,

            [8, 4] => 7,
            [8, 5] => 5,
            [8, 6] => 7,
            [8, 7] => 5,
            [8, 9] => 5,
            [8, tables[2]] => 4,
            [8, tables[3]] => 4,

            [9, 5] => 7,
            [9, 6] => 5,
            [9, 8] => 5,
            [9, tables[3]] => 4,

            [tables[0], 1] => 4,
            [tables[0], 2] => 4,
            [tables[0], 4] => 4,
            [tables[0], 5] => 4,

            [tables[1], 2] => 4,
            [tables[1], 3] => 4,
            [tables[1], 5] => 4,
            [tables[1], 6] => 4,

            [tables[2], 4] => 4,
            [tables[2], 5] => 4,
            [tables[2], 7] => 4,
            [tables[2], 8] => 4,
            
            [tables[3], 5] => 4,
            [tables[3], 6] => 4,
            [tables[3], 8] => 4,
            [tables[3], 9] => 4,


        }
        edge_weights.each { |(p1, p2), w| graph.add_edge(p1, p2) }
    end

    def pathfind start_destination, end_destination
        @graph.dijkstra_shortest_path(@edge_weights, start_destination, end_destination)
    end

end

restaurant = Restaurant.new
print restaurant.pathfind(9, restaurant.kitchen)
