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
        self << link_vertex
        e.connections.each do |c|
          connection = AbstractConnection.new(c)
          self << connection
          self << link_vertex.connect(connection)
          self << connection.connect(self.vertices.find {|v| v.base_vertex == c.end})
        end
      end
      self
    end
  end
  
  class AbstractBox < Vertex
    def initialize(source)
      super()
      self.base_vertex = source
      self
    end
  end
  
  class AbstractEdge < Vertex
    def initialize(source = nil)
      super()
      self.base_edge = source unless source.nil?
      self
    end
  end
  
  class AbstractConnection < Vertex
    def initialize(source = nil)
      super()
      self.base_connection = source unless source.nil?
      self
    end
  end
end
