require 'rgl/adjacency'
require 'rgl/dot'
require 'rgl/dijkstra'
require './kitchen.rb'
require './table.rb'


class Restaurant
    attr_reader :tables, :kitchen, :entrance, :graph, :edge_weights
    def initialize
        @graph = RGL::DirectedAdjacencyGraph.new
        @tables = [Table.new, Table.new, Table.new, Table.new, Table.new, Table.new, Table.new]
        @kitchen = Kitchen.new
        #@graph.add_vertices 1,2,3,4, @kitchen
        @edge_weights = 
        {
            [1, 2] => 1,
            [1, 4] => 1,
            [1, @tables[0]] => 2,
            [1, @tables[6]] => 2,
            [1, @kitchen] => 1,
            [@kitchen, 1] => 1,

            [2, 1] => 1,
            [2, 3] => 1,
            [2, @tables[0]] => 2,
            [2, @tables[6]] => 2,
            [2, @tables[5]] => 2,
            [2, @tables[4]] => 2,
            
            [3, 2] => 1,
            [3, 4] => 1,
            [3, @tables[0]] => 2,
            [3, @tables[2]] => 2,
            [3, @tables[3]] => 2,
            [3, @tables[4]] => 2,

            [4, 1] => 1,
            [4, 3] => 1,
            [4, @tables[0]] => 2,
            [4, @tables[1]] => 2,
            [4, @tables[2]] => 2,

            [@tables[0], 1] => 2,
            [@tables[0], 2] => 2,
            [@tables[0], 3] => 2,
            [@tables[0], 4] => 2,

            [@tables[1], 4] => 2,

            [@tables[2], 4] => 2,
            [@tables[2], 3] => 2,

            [@tables[3], 3] => 2,

            [@tables[4], 3] => 2,
            [@tables[4], 2] => 2,

            [@tables[5], 2] => 2,

            [@tables[6], 1] => 2,
            [@tables[6], 2] => 2,

        }
        @edge_weights.each { |(p1, p2), w| graph.add_edge(p1, p2) }
    end

    def pathfind start_destination, end_destination
        @graph.dijkstra_shortest_path(@edge_weights, start_destination, end_destination)
    end

end

restaurant = Restaurant.new
#print restaurant.pathfind(restaurant.tables[1], restaurant.tables[5])
restaurant.graph.write_to_graphic_file(fmt = 'png', dotfile = "graph")
