require 'spec_helper'

module ErdHandler
  describe Label do
    describe '#initialize' do
      it 'should give an error if not given an original string' do
        # Label.new.should raise_error(ArgumentError)
        expect {Label.new}.to raise_error(ArgumentError)
      end
      
      it 'should create a copy of the original as the processed string' do
        test_label = 'Test label'
        l1 = Label.new test_label
        l1.original.should == test_label
      end
      
      it 'should tidy the processed string if asked' do
        test_label = 'testingLabeller string, he_pontificated'
        l1 = Label.new test_label.dup, true
        l2 = Label.new test_label.dup
        l2.split.downcase.stem
        l1.processed.should == l2.processed
      end
    end # initialze
    
    describe '#original' do
      it 'reports the string it was initialised with' do
        test_label = 'Test label'
        l1 = Label.new test_label
        l1.original.should == test_label
        #l1 = Label.new
        #l1.original.should == ''
      end
    end # original

    describe '#processed' do
      it 'reports the original if no processing has been done' do
        test_label = 'Test label'
        l1 = Label.new test_label
        l1.processed.should == [test_label]
        l1.original.should == test_label
      end
    end # processed

    describe '#split' do
      it 'splits the original on the specified regexp' do
        l1 = Label.new 'Test label'
        l1.split(/ /)
        l1.processed.should == ['Test', 'label']
        l1.original.should == 'Test label'
        
        l1 = Label.new 'Test_label'
        l1.split(/_/)
        l1.processed.should == ['Test', 'label']
        
        l1 = Label.new 'Test label_string'
        l1.split(/[ _]/)
        l1.processed.should == ['Test', 'label', 'string']
      end
      
      it 'splits the original on camel case' do
        l1 = Label.new 'TestLabel'
        l1.split :camel_case => true
        l1.processed.should == ['Test', 'Label']
        l1.original.should == 'TestLabel'

        l2 = Label.new 'testLabel'
        l2.split :camel_case => true
        l2.processed.should == ['test', 'Label']
        l2.original.should == 'testLabel'
      end

      it 'does not split the original on camel case if asked not to' do
        l1 = Label.new 'TestLabel'
        l1.split :camel_case => false
        l1.processed.should == ['TestLabel']
        l1.original.should == 'TestLabel'
        
        l2 = Label.new 'TestLabel'
        l2.split :camel_case => nil
        l2.processed.should == ['TestLabel']
        l2.original.should == 'TestLabel'
      end

      it 'splits the original on numbers' do
        l1 = Label.new 'Test123Label'
        l1.split :numbers => true
        l1.processed.should == ['Test', '123', 'Label']
        l1.original.should == 'Test123Label'

        l2 = Label.new 'test1label'
        l2.split :numbers => true
        l2.processed.should == ['test', '1', 'label']
        l2.original.should == 'test1label'
      end

      it 'does not split the original on numbers if asked not to' do
        l1 = Label.new 'Test123Label'
        l1.split :numbers => false
        l1.processed.should == ['Test123Label']
        l1.original.should == 'Test123Label'
        
        l2 = Label.new 'Test123Label'
        l2.split :numbers => nil
        l2.processed.should == ['Test123Label']
        l2.original.should == 'Test123Label'
      end
      
      it 'splits the original using a default regexp' do
        l1 = Label.new "Test label_string\tfred"
        l1.split
        l1.processed.should == ['Test', 'label', 'string', 'fred']
      end
      
      it 'splits the original on camel case by default' do
        l1 = Label.new 'TestLabel'
        l1.split
        l1.processed.should == ['Test', 'Label']
        l1.original.should == 'TestLabel'
      end

      it 'splits the original on numbers by default' do
        l1 = Label.new 'Test123Label'
        l1.split
        l1.processed.should == ['Test', '123', 'Label']
        l1.original.should == 'Test123Label'
      end
     
      it 'splits the original on punctuation, whitespace, camel case, and numbers by default' do
        l1 = Label.new 'TestLabel is_split, 123 he,said456Fred'
        l1.split
        l1.processed.should == ['Test', 'Label', 'is', 'split','123', 'he', 'said', '456', 'Fred']
        l1.original.should == 'TestLabel is_split, 123 he,said456Fred'
      end

      it 'is idempotent' do
        l1 = Label.new 'TestLabel is_split, 123 he,said456Fred'
        res1 = l1.split.dup
        res2 = l1.split
        res1.processed.should == res2.processed
        l1.original.should == 'TestLabel is_split, 123 he,said456Fred'
      end
    end # split

    describe '#downcase' do
      it 'downcases all parts of the processed label' do
        l1 = Label.new 'Test label_string'
        l1.split.downcase
        l1.processed.should == ['test', 'label', 'string']
      end
    end # downcase
    
    describe '#stem' do
      it 'stems all parts of the processed label' do
        l1 = Label.new 'testing labeller string pontificated'
        l1.split.stem
        l1.processed.should == ['test', 'label', 'string', 'pontif']
      end
    end # stem
    
    describe '#tidy' do
      it 'tidies a label' do
        l1 = Label.new 'testingLabeller string, he_pontificated'
        l2 = Label.new l1.original
        l1.tidy
        l2.split.downcase.stem
        l1.processed.should == l2.processed
      end
    end # tidy
    
    describe '#length' do
      it 'returns the length of the processed label' do
        l1 = Label.new 'testingLabeller string, he_pontificated'
        l1.tidy
        l1.length.should == l1.processed.join('').length
      end
    end # length
    
    describe '#levenshtein' do
      it 'calculates the Levenshtein distance of the processed string' do
        l1 = Label.new 'Fred'
        l1.levenshtein('Fred').should == 0
        l1.levenshtein('Free').should == 1
        l1.levenshtein('').should == 4
        l2 = Label.new ''
        l2.levenshtein('Free').should == 4
        l2.levenshtein('').should == 0
        l3 = Label.new 'meilenstein'
        l3.levenshtein('levenshtein').should == 4
        l4 = Label.new 'testingLabeller string, he_pontificated'
        l4.tidy.levenshtein('testlabelstringhepontif').should == 0
        l4.tidy.levenshtein('testlabelXstringhepontif').should == 1
      end
      
      it 'calculates the Levenshtein distance between Labels' do
        l1 = Label.new 'meilenstein'
        l2 = Label.new 'levenshtein'
        l1.levenshtein(l2).should == 4
      end
    end
    
  end
end
