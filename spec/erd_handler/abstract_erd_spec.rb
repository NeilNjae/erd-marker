require 'spec_helper'

module ErdHandler
  describe AbstractErd do
    describe "#initialize" do
      it "creates an empty abstract ERD" do
        aerd = AbstractErd.new
        aerd.should have(0).vertices
        aerd.should have(0).edges       
      end
      
      it "reads and creates a single box" do
        erd = Erd.new(File.new("spec/fixtures/single_box_erd.xml"))
        aerd = AbstractErd.new(erd)
        aerd.mark.should == 6.5
        aerd.should have(1).vertices
        aerd.should have(0).edges
      end
    end # #initialize
    
    describe "#abstract" do
      it "reads and creates a single box" do
        erd = Erd.new(File.new("spec/fixtures/single_box_erd.xml"))
        aerd = AbstractErd.new
        aerd.abstract erd
        aerd.mark.should == 6.5
        aerd.should have(1).vertices
        aerd.should have(0).edges
      end

      it "reads and creates two boxes with an edge joining them" do
        erd = Erd.new(File.new("spec/fixtures/two_boxes_one_link_erd.xml"))
        aerd = AbstractErd.new
        aerd.abstract erd
        aerd.mark.should == 4.5
        aerd.should have(3).vertices
        aerd.should have(2).edges
      end
    end # #abstract
    
  end
end
