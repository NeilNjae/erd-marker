module ErdHandler
  class Link < Edge
    def initialize(link_element = nil, vertices = nil)
      super()
      read(link_element, vertices) unless link_element.nil?
      self
    end
    
    def read(link_element, vertices)
      self.id = link_element.attributes["id"].to_i
      self.mark = link_element.attributes["mark"].to_f
      
    end
  end
end