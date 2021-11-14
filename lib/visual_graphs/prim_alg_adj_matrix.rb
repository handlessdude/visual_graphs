#require_relative 'adjacency_matrix_graph'

module  VisualGraphs

  class PrimMinimumSpanningTree

    INT_MAX = Float::INFINITY

    def initialize(graph)
      @graph = graph
      @included_nodes = {}
      @included_edges = []
      @excluded_nodes = {}
      @min_heap = MinHeap.new
    end

    def minimum_spanning_tree

      # TODO
      @graph.update_keys(INT_MAX)

      # setup the heap of nodes and the excluded sets
      @graph.vertices.values.each_with_index do |node, index|
        node.key = 0 if index.zero?
        @excluded_nodes[node.name] = node
        @min_heap << node
      end

      # while there are nodes that exist in the excluded set
      while @excluded_nodes.count.positive?

        # find the node that has the minimum key
        min_node = @min_heap.extract_min

        # find the minimum edge from this min node to the included set of nodes
        min_edge = find_min_edge(min_node, @min_heap, @included_nodes)

        @included_edges << min_edge unless min_edge.nil?
        @included_nodes[min_node.name] = min_node
        @excluded_nodes.delete(min_node.name)

      end

      # check to ensure accuracy
      return @included_edges if @included_edges.count == (@graph.vertices.count - 1)

      nil

    end

    private


    # find the minimum edge from the min_node (from excluded to group) to those nodes already included
    # recompute keys and parents for nodes as applicable
    def find_min_edge(min_node, min_heap, included_nodes)
      min_edge_weight = INT_MAX
      min_edge_index = nil

      # loop through all of min_node's neighbor nodes
      # pick the node that is in the included_nodes that has smallest edge weight
      # TODO neighbours maybe?
      min_node.neighbors.each_with_index do |neighbor, index|

        # reconstruct the key and parent for adjacent nodes that are not already included
        if min_node.edges[index].weight < neighbor.key

          neighbor.parent = min_node.name
          neighbor.key = min_node.edges[index].weight

          if min_heap.contains_element(neighbor)
            min_heap.delete_element(neighbor)
            min_heap << neighbor
          end
        end

        # if the neighbor node is not excluded (meaning it is in the set)
        if min_node.edges[index].weight < min_edge_weight && included_nodes.key?(neighbor.name)
          min_edge_weight = min_node.edges[index].weight
          min_edge_index = index
        end

      end

      min_edge = min_node.edges[min_edge_index] unless min_edge_index.nil?

      min_edge

    end

  end

end
