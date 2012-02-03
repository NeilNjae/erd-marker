class Label 
  
  attr_reader :original, :processed
  
  def initialize(original)
    @original = original
    @processed = [original]
  end
  
  def split(opts = {})
    if opts.class == Regexp
      regexp = opts
      split_camel_case = true
    else
      regexp = opts[:regexp] || /[\t\n _,.-]+/
      if opts.has_key? :camel_case
        split_camel_case = opts[:camel_case]
      else
        split_camel_case = true
      end
      if opts.has_key? :numbers
        split_numbers = opts[:numbers]
      else
        split_numbers = true
      end
    end
    @processed = @processed.map do |segment|
      segment.split(regexp)
    end.flatten
    
    if split_camel_case
      @processed = @processed.map do |segment|
        segment.split(/(?<=[a-z])(?=[A-Z])/)
      end.flatten
    end
    
    if split_numbers
      @processed = @processed.map do |segment|
        segment.split(/(?:(?<!\d)(?=\d))|(?:(?<=\d)(?!\d))/)
      end.flatten
    end
    self
  end
  
  def downcase
    @processed = @processed.map do |segment| segment.downcase end
    self
  end
  
  def stem(gb_english = false)
    @processed = @processed.map do |segment| segment.stem(gb_english) end
    self
  end
  
  def tidy
    self.split.downcase.stem
  end
end