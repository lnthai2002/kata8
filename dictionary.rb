module BinarySearch
  #Search an array for an element matching the given target
  def search(array, target, min_index=0, max_index=array.size-1) #normally, >2 params start to get developer confuse, but in this case the rest 2 are optional which is used internally so i leave it 4
    if (max_index < min_index)
      return false
    else
      line_mid = (min_index + max_index)/2

      suspect = array[line_mid].strip.downcase
      if (suspect > target) # target is in lower subset
        return search(array, target, min_index, line_mid-1)
      elsif (suspect < target) # target is in upper subset
        return search(array, target, line_mid+1, max_index)
      else
        return true
      end
    end
  end
end

module TreeTraversal
private
  def search(tree, target)
    if target.size == 1 #last char
      if tree[target] == nil #this path dont have this char
        return false
      elsif tree[target][:end] == :end #yay, we reach then end of the path too
        return true
      else #nope, this path contain words longer than target
        return false
      end
    else #still have char
      first_char = target[0]
      subtarget = target[1..-1] #the rest of the target word
      subtree = tree[first_char]
      if subtree == nil #dead end
        return false
      else
        return search(subtree,subtarget)
      end
    end
  end

  #Parse the wordlist, build a tree of words
  def build_tree(filename)
    tree = Hash.new
    File.open(filename, 'r') do |file|
      file.each_line do |line|
        word = line.strip.downcase #remove LF,CR
        add(word, tree)
      end
    end
    return tree
  end
  
  #store a word 'here' as : {h=>{e=>{r=>{:end=>:end, e=>{:end=>:end}}}}}
  def add(word, tree)
    if word != ''
      first_char = word[0]
      subword = word[1..-1] #the rest of the word
      subtree = tree[first_char]
      if subtree == nil #first time encounter this char in this path
        tree[first_char] = subtree = {}
      end
      tree[first_char] = add(subword, subtree)
      return tree
    else
      return {:end=>:end}
    end
  end
end

#Dictionary binds to a wordlist.txt and provide methods to check if word is valid, as well as other fun filter 
class Dictionary
#  include BinarySearch #ready to swap in a different search algorithm if needed
  include TreeTraversal
  WORDLIST = './wordlist.txt'
  
  def initialize
#    @file = File.readlines(WORDLIST)#I am trading space for time: read all in memory for fast processing
    @file = build_tree(WORDLIST)
  end

  #expect word in downcase for correctness. Return true or false
  def contain?(word)
    return search(@file, word)
  end

  #print all words which made up by 2 words in the wordlist
  def words_contain_2_words
    start_time = Time.now

    File.open(WORDLIST, 'r') do |file|
      file.each_line do |line|
        line = line.strip #line have CR/LF
        if line.size == 6
          words = extract_words(line) #an array or words, each broken down into 2 words
          unless words.empty?
            words.each do |word_set| #each word_set is an array of 2 words
              puts word_set.join('; ')  
            end
          end
        end
      end
    end
    puts "start at: #{start_time}"
    puts "end at: #{Time.now}"
  end

private

  #split the string by 2 words (if possible) and return them
  def extract_words(string)
    words = []
    (1..3).each do |length| #break the string by half at position 1,2,3
      first = string[0..length]
      second = string[length+1..string.size-1]
      
      if contain?(first.downcase) && contain?(second.downcase)
        words << [first, second]
      end
    end

    return words
  end
end

dictionary = Dictionary.new
dictionary.words_contain_2_words