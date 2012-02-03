require 'spec_helper'

module ErdHandler
  describe Label do
    describe '#original' do
      it "reports the string it was initialised with" do
        test_label = "Test label"
        l1 = Label.new test_label
        l1.original.should == test_label
      end
    end # original

    describe '#processed' do
      it "reports the original if no processing has been done" do
        test_label = "Test label"
        l1 = Label.new test_label
        l1.processed.should == [test_label]
        l1.original.should == test_label
      end
    end # processed

    describe '#split' do
      it "splits the original on the specified regexp" do
        l1 = Label.new "Test label"
        l1.split(/ /)
        l1.processed.should == ["Test", "label"]
        l1.original.should == "Test label"
        
        l1 = Label.new "Test_label"
        l1.split(/_/)
        l1.processed.should == ["Test", "label"]
        
        l1 = Label.new "Test label_string"
        l1.split(/[ _]/)
        l1.processed.should == ["Test", "label", "string"]
      end
      
      it "splits the original on camel case" do
        l1 = Label.new "TestLabel"
        l1.split :camel_case => true
        l1.processed.should == ["Test", "Label"]
        l1.original.should == "TestLabel"

        l2 = Label.new "testLabel"
        l2.split :camel_case => true
        l2.processed.should == ["test", "Label"]
        l2.original.should == "testLabel"
      end

      it "doesn't split the original on camel case if asked not to" do
        l1 = Label.new "TestLabel"
        l1.split :camel_case => false
        l1.processed.should == ["TestLabel"]
        l1.original.should == "TestLabel"
        
        l2 = Label.new "TestLabel"
        l2.split :camel_case => nil
        l2.processed.should == ["TestLabel"]
        l2.original.should == "TestLabel"
      end
      
      it "splits the original using a default regexp" do
        l1 = Label.new "Test label_string"
        l1.split
        l1.processed.should == ["Test", "label", "string"]
      end
      
      it "splits the original on camel case by default" do
        l1 = Label.new "TestLabel"
        l1.split
        l1.processed.should == ["Test", "Label"]
        l1.original.should == "TestLabel"
      end

      it "splits the original on punctuation and camel case by default" do
        l1 = Label.new "TestLabel is_split, he,said"
        l1.split
        l1.processed.should == ["Test", "Label", "is", "split", "he", "said"]
        l1.original.should == "TestLabel is_split, he,said"
      end

      it "is idempotent" do
        l1 = Label.new "TestLabel is_split, he,said"
        res1 = l1.split.dup
        res2 = l1.split
        res1.processed.should == res2.processed
        l1.original.should == "TestLabel is_split, he,said"
      end
    end # split

    describe "#downcase" do
      it "downcases all parts of the processed label" do
        l1 = Label.new "Test label_string"
        l1.split.downcase
        l1.processed.should == ["test", "label", "string"]
      end
    end # downcase
    
    describe "#stem" do
      it "stems all parts of the processed label" do
        l1 = Label.new "testing labeller string pontificated"
        l1.split.stem
        l1.processed.should == ["test", "label", "string", "pontif"]
      end
    end # stem
    
    describe "#tidy" do
      it "tidies a label" do
        l1 = Label.new "testingLabeller string, he_pontificated"
        l2 = Label.new l1.original
        l1.tidy
        l2.split.downcase.stem
        l1.processed.should == l2.processed

      end
    end # tidy
    
  end
end
