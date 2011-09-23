module Erd
  class Erd
    def initialize(source = nil)
      doc = Document.new source
      raise InvalidErdFile unless doc.elements.length == 1 and doc.elements[1].name.downcase == 'drawing'
    end
  end
end
