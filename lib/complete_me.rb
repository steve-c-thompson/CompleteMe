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
    chars = word.chars
    if(@words.add_child(chars, 0))
      @count += 1
    end
  end
end
