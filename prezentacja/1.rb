# https://www.rubydoc.info/github/monora/rgl/RGL/Graph

require 'rgl/adjacency'
require 'rgl/base'
graph = RGL::DirectedAdjacencyGraph.new
graph.add_edge 1,2
graph.add_vertices 1, 2, 3, 4, 5, "1", 1.to_s.to_sym
edge_weights = 
{
    [1, 2] => 1,
    [1, 6] => 1,
    [6, 5] => 1,
    [2, 3] => 1,
    [2, 4] => 2,
    [4, 5] => 5,
    [5, 1] => 1,
    [2, "1"] => 2,
    [3, :"1"] => 3
}
edge_weights.each { |(p1, p2), w| graph.add_edge(p1, p2) }
print graph.edges
puts ''
print graph.vertices
puts ''
k6 = RGL::AdjacencyGraph.new
#k6.add_vertices 1, 2, 3, 4, 5, 6
(1..6).each do |x|
    (1..6).each do |y|
        unless x == y then k6.add_edge x, y end
    end
end
puts k6.edges
require 'rgl/traversal'
#print graph.bfs_search_tree_from(1)
puts graph.bfs_search_tree_from(1)
graph.depth_first_visit(1) { |d| puts d }
require 'rgl/dot'
graph.write_to_graphic_file('jpg')
#puts graph.adjacent_vertices(1)


require 'rgl/bellman_ford'
#puts graph.bellman_ford_shortest_paths(edge_weights, 1)

require 'rgl/dijkstra'
#puts graph.dijkstra_shortest_paths(edge_weights, 1)
