module ErdHandler
  class AbstractErd < Graph
    def initialize(source = nil)
      super()
      abstract(source) unless source.nil?
      self
    end
    
    # Create an abstract ERD from a base ERD.
    # An abstract ERD has an additional vertex for each link and each end of the link
    def abstract(erd)
      self.mark = erd.mark
      self.name = erd.name
      erd.vertices.each do |v|
        self << AbstractBox.new(v)
        # also do links for containment
      end
      erd.edges.each do |e|
        link_vertex = AbstractLink.new(e)
        self << link_vertex
        e.connections.each do |c|
          connection = AbstractLinkEnd.new(c)
          self << connection
          self << link_vertex.connect(connection)
          self << connection.connect(self.vertices.find {|v| v.base_vertex == c.end})
        end
      end
      self
    end
  end
  
  class AbstractBox < Vertex
    def initialize(source = nil)
      super()
      self.base_vertex = source unless source.nil?
      self
    end
  end
  
  class AbstractLink < Vertex
    def initialize(source = nil)
      super()
      self.base_link = source unless source.nil?
      self
    end
  end
  
  class AbstractLinkEnd < Vertex
    def initialize(source = nil)
      super()
      self.base_link_end = source unless source.nil?
      self
    end
  end
end
