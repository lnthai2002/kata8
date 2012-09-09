require 'ruby-debug'
#Dictionary bind to a wordlist.txt and provide methods to check if word is valid 
class Dictionary
  WORDLIST = './wordlist.txt'
  def initialize
    @file = File.readlines(WORDLIST)
  end

  #expect word in downcase for correctness
  def contain?(word)
    binary_search(@file, word, 0, @file.size-1)
  end

  def words_contain_2_words
    start_time = Time.now

    @file.each do |line|
      line = line.strip #line have CR/LF
      if line.size == 6
        words = extract_words(line)  
        unless words.empty?
          words.each do |w|
            puts w.join('; ')  
          end
        end
      end
    end
    puts "start at: #{start_time}"
    puts "end at: #{Time.now}"
  end

private

  #please pass target in downcase
  def binary_search(file, target, line_min, line_max)
    if (line_max < line_min)
      return false
    else
      line_mid = (line_min + line_max)/2

      suspect = file[line_mid].strip.downcase
      if (suspect > target)# key is in lower subset
        return binary_search(file, target, line_min, line_mid-1)
      elsif (suspect < target)# key is in upper subset
        return binary_search(file, target, line_mid+1, line_max)
      else# key has been found
        return suspect
      end
    end
  end

  #split the string by 2 words (if possible) and return them
  def extract_words(string)
    words = []
    (1..3).each do |length| #break the string by half at position 1,2,3
      first = string[0..length]
      second = string[length+1..string.size-1]
      
      if contain?(first.downcase) && contain?(second.downcase)
        words <<  [first, second]
      end
    end

    return words
  end
end

dic = Dictionary.new
dic.words_contain_2_words