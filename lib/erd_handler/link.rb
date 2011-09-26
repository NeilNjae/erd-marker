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
 puts "vertices = #{vertices}"      
      box1 = vertices.select {|v| v.id == link_element.elements['box1'].attributes['id']}[0]
 puts "found box1: #{box1}"     
      box2 = vertices.select {|v| v.id == link_element.elements['box2'].attributes['id']}[0]
 puts "found box2: #{box2}"
      self << box1 << box2
      c1 = self.connections.find {|c| c.end == box1}
      c1.blob = link_element.elements['box1EndAdornments'].attributes['blob']
      c1.crowsfoot = link_element.elements['box1EndAdornments'].attributes['crowsfoot']
      c2 = self.connections.find {|c| c.end == box2}
      c2.blob = link_element.elements['box2EndAdornments'].attributes['blob']
      c2.crowsfoot = link_element.elements['box2EndAdornments'].attributes['crowsfoot']
    end
  end
end
