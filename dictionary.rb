require 'ruby-debug'
#Dictionary bind to a wordlist.txt and provide methods to check if word is valid 
class Dictionary
  WORDLIST = './wordlist.txt'
  def contain?(word)
    File.open(WORDLIST, 'r') do |file|
      file.each_line do |line|
        if line.strip.downcase == word.downcase #line have CR/LF
          return true
        end
      end
    end
    return false
  end

  def words_contain_2_words
    start_time = Time.now
    file = File.open(WORDLIST, 'r')
    file.each_line do |line|
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

  def extract_words(string)
    words = []
    (1..3).each do |length|
      first = string[0..length]
      second = string[length+1..string.size-1]
      if contain?(first) && contain?(second)
        words <<  [first, second]
      end
    end
    return words
  end
end

dic = Dictionary.new
dic.words_contain_2_words