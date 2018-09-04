class CompleteMe
  attr_reader :count
  def initialize(opts = {})
    @count = 0
    @words = Node.new
  end

  class Node
    attr_reader :letter, :children
    def initialize(letter=nil, valid_word=false)
      @letter = letter
      @children = {}
      @valid = valid_word
    end

    def to_s
      "Node: #{@letter ? @letter : "nil"}, #{@children}, #{@valid}"
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
            return false
          end
        else
          # add this letter node as a child
          child = Node.new(node_letter, leaf_node)
          @children[node_letter] = child
          if(leaf_node)
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
      chars = word.chars
      node = find_leaf_node(chars)
      if(node)
        # depth-first search the node's children for valid words
        suggest_words(node, word, suggestions)
      end
    end
    suggestions
  end

  private

  def suggest_words(node, word, words_array)
    if(node.children)
      node.children.values.each do |child|
        # add this node's letter to letters
        new_word = word + child.letter
        if(child.valid?)
          words_array << new_word
        end
        suggest_words(child, new_word, words_array)
      end
    end
  end

  def find_leaf_node(chars)
    node = nil
    word_set = @words.children
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
