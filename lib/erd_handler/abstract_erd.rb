module ErdHandler
  class AbstractErd < Graph
    def initialize(source = nil)
      super()
      abstract(source) unless source.nil?
      self
    end
    
    # Create an abstract ERD from a base ERD.
    # An abstract ERD has an additional node for each link
    def abstract(erd)
      self.mark = erd.mark
      self.name = erd.name
      erd.vertices.each do |v|
        self << AbstractBox.new(v)
        # also do links for containment
      end
      erd.edges.each do |e|
        link_vertex = AbstractEdge.new(e)
        e.connections.each do |c|
          # find the abstract vertex at this end
          # connect the abstract link to it
        end
      end
      self
    end
  end
  
  class AbstractBox < Vertex
    def initialize(souce = nil)
      super()
      self.base_vertex = source unless source.nil?
      self
    end
  end
  
  class AbstractEdge < Vertex
    def initialize(source = nil)
      super()
      self.base_vertex = source unless source.nil?
      self
    end
  end
end
