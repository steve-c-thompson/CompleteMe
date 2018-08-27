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
      @children = []
      @valid = valid_word
    end

    def valid?
      @valid
    end

    def add_child(letters, begin_index, end_index)
      if(letters.length > 0)
        # if letters has only one letter, this is a valid node
        child_node = get_child(letters[0])
        if(child_node != nil)
          # if this node is in children, don't add a new one, but call add_child

        else
          # add this node as a child

        end

        # return true if this succeeded in adding a new word
      end
    end

    def get_child(letter)
      nil
    end
  end

  def insert(word)
    chars = word.chars
    if(@words.add_child(chars, 0, chars.length-1))
      @count += 1
    end
  end
end
