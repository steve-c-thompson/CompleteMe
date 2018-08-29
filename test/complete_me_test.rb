require_relative './test_helper'
require './lib/complete_me'

class CompleteMeTest < Minitest::Test
  def test_it_exists
    complete_me = CompleteMe.new
    assert_instance_of CompleteMe, complete_me

    complete_me = CompleteMe.new({})
    assert_instance_of CompleteMe, complete_me
  end

  def test_it_has_a_word_count
    complete_me = CompleteMe.new

    assert_equal 0, complete_me.count
  end

  def test_it_can_insert_words_and_update_word_count
    complete_me = CompleteMe.new
    complete_me.insert("pizza")

    assert_equal 1, complete_me.count
  end

  def test_it_does_not_insert_duplicaates_and_update_word_count
    complete_me = CompleteMe.new
    complete_me.insert("pizza")
    complete_me.insert("pizza")

    assert_equal 1, complete_me.count
  end

  def test_it_can_suggest_items_in_dictionary
    skip
    complete_me = CompleteMe.new
    complete_me.insert("pizza")

    sug = complete_me.suggest("piz")
    assert_equal ["pizza"], sug
  end

end
