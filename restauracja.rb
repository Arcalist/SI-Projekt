require 'rgl/adjacency'
require 'rgl/dot'
require 'rgl/dijkstra'
require './kitchen.rb'
require './table.rb'


class Restaurant
    attr_reader :tables, :kitchen, :routes, :graph
    def initialize
        @graph = RGL::AdjacencyGraph.new
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


            [2, 3] => 1,
            [2, @tables[0]] => 2,
            [2, @tables[6]] => 2,
            [2, @tables[5]] => 2,
            [2, @tables[4]] => 2,
            

            [3, 4] => 1,
            [3, @tables[0]] => 2,
            [3, @tables[2]] => 2,
            [3, @tables[3]] => 2,
            [3, @tables[4]] => 2,


            [4, @tables[0]] => 2,
            [4, @tables[1]] => 2,
            [4, @tables[2]] => 2

        }
        @edge_weights.each { |(p1, p2), w| @graph.add_edge(p1, p2) }
        @routes = Hash.new
        @graph.vertices.each do |x| 
            @routes[x] = @graph.dijkstra_shortest_paths(@edge_weights, x)
        end
    end


end

restaurant = Restaurant.new
puts restaurant.routes[restaurant.kitchen][restaurant.tables[3]]

