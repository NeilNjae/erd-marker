require 'spec_helper'

module Erd
  describe Erd do
    let(:input) { double('input').as_null_object }
    let(:output) { double('output').as_null_object }
    let(:erd) { Erd.new(input, output) }
    
    describe "#read" do
      it "reads a single box" do
	doc = Document.new File.new("spec/fixtures/single_box_erd.xml")
	erd = Erd.new doc
	erd.mark.should == 6.5
	erd.boxes.length.should == 1
	
      end
    end # #read
  end
end