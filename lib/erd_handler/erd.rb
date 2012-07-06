module ErdHandler
  class Erd < Graph
    def initialize(source = nil)
      super()
      read(source) unless source.nil?
      self
    end
    
    def read(source)
      doc = REXML::Document.new(source)
      raise(InvalidErdFile, "#{source} doesn't contain a drawing element") unless doc.elements[1].name.downcase == 'drawing'
      raise(InvalidErdFile, "#{source} doesn't have one drawing element") unless doc.elements.to_a.length == 1
      self.mark = doc.elements['Drawing'].attributes['mark'].to_f
      self.name = Label.new doc.elements['Drawing'].attributes['name']
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
    
    # The minimal meaningful units of an ERD are:
    #  Each box in isolation
    #  Each link, with the associated boxes at its ends
    def mmus
      mmus = []
      self.vertices.each do |b| 
        mmu = Erd.new
        mmu << b
        mmus << mmu 
      end
      self.edges.each do |l| 
        mmu = Erd.new
        l.vertices.each do |b|
          mmu << b
        end
        mmu << l
        mmus << mmu
      end
      mmus
    end
    
  end
end
