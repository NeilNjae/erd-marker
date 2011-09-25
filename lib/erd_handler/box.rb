module ErdHandler
  class Box < Vertex
    def initialize(box_element = nil)
      super()
      read(box_element) unless box_element.nil?
      self
    end # initialize
    
    def read(box_element)
      self.id = box_element.attributes["id"].to_i
      self.name = box_element.attributes["name"]
      self.mark = box_element.attributes["mark"].to_f
      
      self.x = box_element.elements["location"].attributes["x"].to_f
      self.y = box_element.elements["location"].attributes["y"].to_f
      self.width = box_element.elements["size"].attributes["width"].to_f
      self.height = box_element.elements["size"].attributes["height"].to_f
      self.comment = box_element.elements["comment"].text
      self
    end
    
  end
end
