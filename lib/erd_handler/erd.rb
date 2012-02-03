module ErdHandler
  class Erd < Graph
    def initialize(source = nil)
      super()
      read(source) unless source.nil?
      self
    end
    
    def read(source)
      doc = Document.new(source)
      raise InvalidErdFile unless doc.elements.to_a.length == 1 and doc.elements[1].name.downcase == 'drawing'
      self.mark = doc.elements['Drawing'].attributes["mark"].to_f
      self.name = Label.new doc.elements['Drawing'].attributes["name"]
      doc.elements.each('Drawing/box') do |box_element|
        self << Box.new(box_element)
      end
      doc.elements.each('Drawing/link') do |link_element|
        self << Link.new(link_element, self.vertices)
      end
      doc.elements.each('Drawing/selfLink') do |link_element|
        self << Link.new(link_element, self.vertices)
      end
      self
    end
  end
end
