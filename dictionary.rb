#Dictionary bind to a wordlist.txt and provide methods to check if word is valid 
class Dictionary
  WORDLIST = './wordlist.txt'
  def initialize
    #TODO: build data struct for search
    @file = File.open(WORDLIST, 'r')
  end

  def contain?(word)
    File.open(WORDLIST, 'r') do |file|
      file.each_line do |line|
        if line == word
          return true
        end
      end
    end
    return false
  end

  def words_contain_2_words
    @file.each_line do |line|
      if line.size == 6
        words = extract_words(line)
        unless words.empty?
          return words
        end
      end
    end
  end

private

  def extract_words(string)
    (1..3).each do |length|
      first = string[0..length]
      second = string[length+1..string.size-1]
      if contain?(first) && contain?(second)
        return [first, second]
      end
    end
  end
end