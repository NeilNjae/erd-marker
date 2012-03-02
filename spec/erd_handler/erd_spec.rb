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
    end # #initialize
    
    describe "#read" do
      it "reads and creates a single box" do
        erd = Erd.new
        erd.read(File.new("spec/fixtures/single_box_erd.xml"))
        erd.mark.should == 6.5
        erd.should have(1).vertices
        erd.should have(0).edges
      end

      it "reads and creates two boxes with an edge joining them" do
        erd = Erd.new
        erd.read(File.new("spec/fixtures/two_boxes_one_link_erd.xml"))
        erd.mark.should == 4.5
        erd.should have(2).vertices
        erd.should have(1).edges

        erd.vertices[0].should have(1).neighbours
        erd.vertices[1].should have(1).neighbours
        erd.vertices[0].neighbours.should include(erd.vertices[1])
        erd.vertices[1].neighbours.should include(erd.vertices[0])
        
        link = erd.edges[0]
        b0 = erd.vertices.find {|v| v.id == 0}
        b1 = erd.vertices.find {|v| v.id == 1}
        link.connection_at(b0).blob.should be(:closed)
        link.connection_at(b0).crowsfoot.should be(:yes)
        link.connection_at(b1).blob.should be(:open)
        link.connection_at(b1).crowsfoot.should be(:no)
      end
      
      it "reads and creates a box with a self-loop" do
        erd = Erd.new
        erd.read(File.new("spec/fixtures/single_box_self_loop_erd.xml"))
        erd.mark.should == 4.5
        erd.should have(1).vertices
        erd.should have(1).edges

        erd.vertices[0].should have(1).neighbours
        erd.vertices[0].neighbours.should include(erd.vertices[0])
        
        link = erd.edges[0]
        box = erd.vertices[0]
        c1 = link.connections.find {|c| c.blob == :closed}
        c1.crowsfoot.should be(:yes)
        c2 = link.connections.find {|c| c.blob == :open}
        c2.crowsfoot.should be(:no)
        c1.should_not == c2
      end

      it "reads and creates full diagram" do
        erd = Erd.new
        erd.read(File.new("spec/fixtures/complex_erd.xml"))
        erd.mark.should == 4.0
        erd.should have(5).vertices
        erd.should have(6).edges
        
        b0 = erd.vertices.find {|b| b.id == 0}
        b0.name.original.should == "Unit"
        b0.should have(2).neighbours
        
        b1 = erd.vertices.find {|b| b.id == 1}
        b1.name.original.should == "Employee"
        b1.should have(2).neighbours
        
        b2 = erd.vertices.find {|b| b.id == 2}
        b2.name.original.should == "Course"
        b2.should have(3).neighbours

        b3 = erd.vertices.find {|b| b.id == 3}
        b3.name.original.should == "Presentation"
        b3.should have(3).neighbours
        
        b4 = erd.vertices.find {|b| b.id == 4}
        b4.name.original.should == "Client"
        b4.should have(1).neighbours

        l0 = erd.edges.find {|e| e.id == 0}
        l0.name.original.should == "ConsistsOf"
        l0.connections.find {|c| c.end == b0}.blob.should be :closed
        l0.connections.find {|c| c.end == b0}.crowsfoot.should be :yes
        l0.connections.find {|c| c.end == b2}.blob.should be :closed
        l0.connections.find {|c| c.end == b2}.crowsfoot.should be :no

        l1 = erd.edges.find {|e| e.id == 1}
        l1.name.original.should == "Prepares"
        l1.connections.find {|c| c.end == b0}.blob.should be :open
        l1.connections.find {|c| c.end == b0}.crowsfoot.should be :yes
        l1.connections.find {|c| c.end == b1}.blob.should be :closed
        l1.connections.find {|c| c.end == b1}.crowsfoot.should be :no

        l2 = erd.edges.find {|e| e.id == 2}
        l2.name.original.should == "Presents"
        l2.connections.find {|c| c.end == b1}.blob.should be :closed
        l2.connections.find {|c| c.end == b1}.crowsfoot.should be :no
        l2.connections.find {|c| c.end == b3}.blob.should be :closed
        l2.connections.find {|c| c.end == b3}.crowsfoot.should be :yes

        l3 = erd.edges.find {|e| e.id == 3}
        l3.name.original.should == "Presented"
        l3.connections.find {|c| c.end == b2}.blob.should be :open
        l3.connections.find {|c| c.end == b2}.crowsfoot.should be :no
        l3.connections.find {|c| c.end == b3}.blob.should be :closed
        l3.connections.find {|c| c.end == b3}.crowsfoot.should be :yes

        l4 = erd.edges.find {|e| e.id == 4}
        l4.name.original.should == "Recieves"
        l4.connections.find {|c| c.end == b3}.blob.should be :closed
        l4.connections.find {|c| c.end == b3}.crowsfoot.should be :yes
        l4.connections.find {|c| c.end == b4}.blob.should be :closed
        l4.connections.find {|c| c.end == b4}.crowsfoot.should be :no

        l5 = erd.edges.find {|e| e.id == 5}
        l5.name.original.should == "IsPrerequisiteOf"
        l5.connections.find {|c| c.crowsfoot == :yes}.blob.should be :open
        l5.connections.find {|c| c.crowsfoot == :no}.blob.should be :open
        l5.connections.find {|c| c.crowsfoot == :yes}.end.should be b2
        l5.connections.find {|c| c.crowsfoot == :no}.end.should be b2
      end
    end # #read
    
    describe "#mmus" do
      it "finds three MMUs in a simple ERD" do
        erd = Erd.new
        erd.read(File.new("spec/fixtures/two_boxes_one_link_erd.xml"))
        mmus = erd.mmus
        
        mmus.should have(3).items
        single_box_mmus = mmus.select {|m| m.vertices.length == 1}
        single_link_mmus = mmus.select {|m| m.edges.length == 1}
        
        single_box_mmus.should have(2).items
        single_box_mmus.each do |m|
          m.should have(1).vertices
          m.should have(0).edges
        end
        
        single_link_mmus.should have(1).items
        single_link_mmus.each do |m|
          m.should have(2).vertices
          m.should have(1).edges
          m.edges.first.should have(2).connections
          m.vertices.each do |v|
            m.vertices.should include(v)
          end
        end
      end
      
      it "finds many MMUs in a complex ERD" do
        erd = Erd.new
        erd.read(File.new("spec/fixtures/complex_erd.xml"))
        mmus = erd.mmus
        
        mmus.should have(11).items
        single_box_mmus = mmus.select {|m| m.vertices.length == 1}
        single_link_mmus = mmus.select {|m| m.edges.length == 1}

        single_box_mmus.should have(5).items
        single_box_mmus.each do |m|
          m.should have(1).vertices
          m.should have(0).edges
        end
        single_box_mmus.map {|m| m.vertices.first.name.original}.uniq.should have(5).items
        
        single_link_mmus.should have(6).items
        single_link_mmus.each do |m|
          m.should have(2).vertices
          m.should have(1).edges
          m.edges.first.should have(2).connections
          m.vertices.each do |v|
            m.vertices.should include(v)
          end
        end
        single_link_mmus.map {|m| m.edges.first.name.original}.uniq.should have(6).items
      end

    end # #mmus
  end
end
