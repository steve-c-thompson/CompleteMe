class CompleteMe
  attr_reader :count
  def initialize(opts = {})
    @count = 0
    @words = Node.new
  end

  class Node
    attr_reader :letter, :children
    attr_writer :valid
    attr_accessor :word, :search_selections
    def initialize(letter=nil, valid_word=false)
      @letter = letter
      @children = {}
      @valid = valid_word
    end

    def to_s
      "Node: word: #{word ? word : "nil"}, #{@letter ? @letter : "nil"}, #{@children}, #{@valid}, #{self.search_selections}"
    end

    def valid?
      @valid
    end

    def add_child(letters, begin_index)
      if(begin_index < letters.length)
        # if letters has only one letter, this is a leaf node
        leaf_node = false
        if(begin_index + 1 == letters.length)
          leaf_node = true
        end
        node_letter = letters[begin_index]

        child_node = get_child(node_letter)
        if(child_node)
          if (!leaf_node)
            # if this node is in children, don't add a new one, but call add_child
            return child_node.add_child(letters, begin_index + 1)
          else
            if(child_node.valid?)
              return false
            else
              child_node.valid = true
              child_node.word = letters.join
              return true
            end
          end
        else
          # add this letter node as a child
          child = Node.new(node_letter, leaf_node)
          @children[node_letter] = child
          if(leaf_node)
            child.word = letters.join
            child.search_selections = {}
            return true
          else
            return child.add_child(letters, begin_index + 1)
          end
        end
      end
    end

    def get_child(letter)
      @children[letter]
    end
  end

  def insert(word)
    if(word == nil)
      return
    end
    chars = word.chars
    if(@words.add_child(chars, 0))
      @count += 1
    end
  end

  def populate(dictionary)
    dictionary.split("\n").each do |word|
      insert(word)
    end
  end

  def suggest(word)
    suggestions = []
    # traverse to the last letter of word
    if(word)
      node = find_node(word)
      if(node)
        # depth-first search the node's children for valid words
        suggest_words(node, word, suggestions)
      end
    end
    sorted = sort_suggestions(word, suggestions)

    sorted.map do |n|
      n.word
    end
  end

  def select(input, word)
    # find the node
    node = find_node(word)
    # get its search_selections and add to (or create) its selection->count
    if(node)
      selections = node.search_selections
      num = selections[input]
      if(num)
        num += 1
      else
        num = 1
      end
      selections[input] = num
    end
  end

  private

  def suggest_words(node, word, nodes_array)
    if(node.children)
      node.children.values.each do |child|
        # add this node's letter to letters
        new_word = word + child.letter
        if(child.valid?)
          nodes_array << child
        end
        suggest_words(child, new_word, nodes_array)
      end
    end
  end

  def sort_suggestions(word, suggestions)
    # sort suggestions by the number of times word has been selected
    suggestions.sort do |a, b|
      a_selections = a.search_selections
      b_selections = b.search_selections
      a_num = 0
      b_num = 0
      if(a_selections)
        temp = a_selections[word]
        if(temp)
          a_num = temp
        end
      end
      if(b_selections)
        temp = b_selections[word]
        if(temp)
          b_num = temp
        end
      end
      # this is a reverse sort
      b_num - a_num
    end
  end

  def find_node(word_string)
    node = nil
    word_set = @words.children
    chars = word_string.chars
    chars.each do |c|
      if(word_set)
        node = word_set[c]
        if(node)
          word_set = node.children
        else
          break
        end
      end
    end
    node
  end

end
