require 'spec_helper'

module ErdHandler
  describe Box do
    # Needed as RSpec includes the Psych YAML reader, which defines :y as
    # a method for generating YAML of an object.
    class Box
      undef_method :y
    end

    describe '#contains?' do
      it 'reports when a box contains another' do 
        b1 = Box.new 
        b1.x = 10 ; b1.y = 10 ; b1.width = 20 ; b1.height = 20
        b2 = Box.new ; b2.x =  5 ; b2.y =  5 ; b2.width = 30 ; b2.height = 30
        b3 = Box.new ; b3.x = 15 ; b3.y = 15 ; b3.width = 20 ; b3.height = 20
        
        b1.should_not be_contains(b2)
        b2.should be_contains(b1)
        b1.should_not be_contains(b3)
        b3.should_not be_contains(b1)
      end
    end # contains?

    describe '#within?' do
      it 'reports when a box is within another' do 
        b1 = Box.new 
        b1.x = 10 ; b1.y = 10 ; b1.width = 20 ; b1.height = 20
        b2 = Box.new ; b2.x =  5 ; b2.y =  5 ; b2.width = 30 ; b2.height = 30
        b3 = Box.new ; b3.x = 15 ; b3.y = 15 ; b3.width = 20 ; b3.height = 20
        
        # Can't use the standard RSpec predicate notation as it clashes with 
        # floating-point expectations
        b1.within?(b2).should == true
        b2.within?(b1).should == false
        b1.within?(b3).should == false
        b3.within?(b1).should == false
      end
    end # within?
    
    describe '#similarity' do
      it 'find the similarity of two boxes' do 
        b1 = Box.new
        b1.name = Label.new 'box 1', true
        b2 = Box.new
        b2.name = Label.new 'box 2', true
        b1.similarity(b2).should be_within(0.005).of(0.75)
      end
    end

  end
end
