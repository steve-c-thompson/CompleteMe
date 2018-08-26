class CompleteMe
  attr_reader :count
  def initialize(opts = {})
    @count = 0
    @words = []
  end

  class Node
    attr_reader :letter, :children
    def initialize(letter, valid_word=false)
      @letter = letter
      @children = []
      @valid = valid_word
    end

    def valid?
      @valid
    end
  end

  def insert(word)

  end
end
