require 'spec_helper'

module ErdHandler
  describe Erd do
    let(:input) { double('input').as_null_object }
    let(:output) { double('output').as_null_object }
    let(:erd) { Erd.new(input, output) }
    
    describe "#initialize" do
      it "creates an empty ERD" do
        erd = Erd.new
        erd.mark.should be_nil
        erd.should have(0).vertices
        erd.should have(0).edges       
      end
      
      it "reads and creates a single box" do
        erd = Erd.new(File.new("spec/fixtures/single_box_erd.xml"))
        erd.mark.should == 6.5
        erd.should have(1).vertices
        erd.should have(0).edges
      end
      
      it "reads and creates two boxes with an edge joining them" do
        erd = Erd.new(File.new("spec/fixtures/two_boxes_one_link_erd.xml"))
        erd.mark.should == 4.5
        erd.should have(2).vertices
        erd.should have(1).edges
      end
      
      it "reads and creates a box with a self-loop"
    end # #initialize
  end
end