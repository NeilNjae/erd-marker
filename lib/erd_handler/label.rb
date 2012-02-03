class Label 
  
  attr_reader :original, :processed
  
  def initialize(original = "")
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
  
  def levenshtein(other_object)
    if other_object.class == Label
      other = other_object.processed.join('')
    else
      other = other_object
    end
    s = @processed.join('')
    n = s.length
    m = other.length
    return m if (0 == n)
    return n if (0 == m)
    
    d = Array.new(m+1) {Array.new(n+1, 0)} # one row for each characer in other, one column for each charater in self
    
    (0..n).each {|i| d[0][i] = i}
    (0..m).each {|j| d[j][0] = j}
    (1..m).each do |i|
      (1..n).each do |j|
        d[i][j] = [d[i-1][j-1] + ((s[j-1] == other[i-1]) ? 0 : 1),  # substitution
                   d[i-1][j] + 1, # deletion
                   d[i][j-1] + 1  # addition
                   ].min
      end
    end
    d[-1][-1]
  end
  
  alias :edit_distance :levenshtein
end