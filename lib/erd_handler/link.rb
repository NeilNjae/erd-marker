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
      self.name = link_element.elements['moveableName'].attributes['name']
      box1 = vertices.select {|v| v.id == link_element.elements['box1'].attributes['id'].to_i}[0]
      box2 = vertices.select {|v| v.id == link_element.elements['box2'].attributes['id'].to_i}[0]
      self << box1 << box2
      box1.edges << self
      box2.edges << self unless box1 == box2
      if box1 == box2
        c1 = self.connections[0]
        c2 = self.connections[1]
      else
        c1 = self.connections.find {|c| c.end == box1}
        c2 = self.connections.find {|c| c.end == box2}
      end
      c1.blob = link_element.elements['box1EndAdornments'].attributes['blob'].downcase.intern
      c1.crowsfoot = link_element.elements['box1EndAdornments'].attributes['crowsfoot'].downcase.intern
      c2.blob = link_element.elements['box2EndAdornments'].attributes['blob'].downcase.intern
      c2.crowsfoot = link_element.elements['box2EndAdornments'].attributes['crowsfoot'].downcase.intern
    end
  end
end
