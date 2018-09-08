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

  def test_it_does_not_insert_empty_words
    complete_me = CompleteMe.new
    complete_me.insert("pizza")

    assert_equal 1, complete_me.count

    complete_me.insert("")
    assert_equal 1, complete_me.count

    complete_me.insert(nil)
    assert_equal 1, complete_me.count
  end

  def test_it_does_not_insert_duplicaates_and_update_word_count
    complete_me = CompleteMe.new
    complete_me.insert("pizza")
    complete_me.insert("pizza")

    assert_equal 1, complete_me.count
  end

  def test_it_inserts_sub_words_and_updates_word_count
    complete_me = CompleteMe.new
    complete_me.insert("pizza")
    complete_me.insert("piz")

    assert_equal 2, complete_me.count
  end

  def test_it_returns_no_items_when_there_are_no_suggestions
    complete_me = CompleteMe.new
    complete_me.insert("pizza")

    sug = complete_me.suggest("dog")
    assert_equal [], sug
  end

  def test_it_can_suggest_items_in_dictionary
    complete_me = CompleteMe.new
    complete_me.insert("pizza")

    sug = complete_me.suggest("piz")
    assert_equal ["pizza"], sug
  end

  def test_it_can_suggest_items_in_dictionary_with_intermediate_words
    complete_me = CompleteMe.new
    complete_me.insert("pizzeria")
    complete_me.insert("pi")
    complete_me.insert("pizzazz")
    complete_me.insert("pizza")
    complete_me.insert("pie")
    complete_me.insert("parts")

    sug = complete_me.suggest("piz")
    assert_equal ["pizza", "pizzeria", "pizzazz"].sort, sug.sort

    refute sug.include?('pizzer')

    sug = complete_me.suggest("pizza")
    assert_equal ["pizzazz"], sug
  end

  def test_it_can_add_intermediate_words_and_suggest
    complete_me = CompleteMe.new
    complete_me.insert("pizzas")
    complete_me.insert("pi")

    sug = complete_me.suggest("piz")
    assert_equal ["pizzas"], sug

    refute sug.include?('pizza')

    complete_me.insert('pizza')
    sug = complete_me.suggest("piz")
    assert_equal ["pizza", "pizzas"].sort, sug.sort
  end

  def test_it_does_not_suggest_same_word_as_in_dictionary
    complete_me = CompleteMe.new
    complete_me.insert("pizza")
    complete_me.insert("pizzeria")
    complete_me.insert("pizzazz")

    sug = complete_me.suggest("pizza")
    assert_equal ["pizzazz"].sort, sug.sort
  end

  def test_it_can_populate_from_a_file
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")

    completion.populate(dictionary)

    assert completion.count > 200000
  end

  def test_it_can_select_words
    complete_me = CompleteMe.new

    complete_me.insert("pizza")
    complete_me.insert("pizzeria")
    complete_me.insert("pizzazz")

    sug = complete_me.suggest("piz")

    complete_me.select("piz", "pizzeria")
  end

  def test_it_can_suggest_words_first_which_have_been_selected
    complete_me = CompleteMe.new

    complete_me.insert("pizza")
    complete_me.insert("pizzeria")
    complete_me.insert("pizzazz")

    expected = ["pizza", "pizzeria", "pizzazz"].sort

    sug = complete_me.suggest("piz")
    assert_equal expected, sug.sort

    complete_me.select("piz", "pizzeria")
    expected.delete("pizzeria")
    expected.unshift("pizzeria")

    sug = complete_me.suggest("piz")
    assert_equal "pizzeria", sug[0]

    # select a different words to move to front

    complete_me.select("piz", "pizza")
    complete_me.select("piz", "pizza")

    sug = complete_me.suggest("piz")
    assert_equal "pizza", sug[0]
  end

  def test_it_suggests_words_and_sub_words_based_on_selections
    completion = CompleteMe.new

    dictionary = File.read("/usr/share/dict/words")

    completion.populate(dictionary)

    completion.select("piz", "pizzeria")
    completion.select("piz", "pizzeria")
    completion.select("piz", "pizzeria")

    completion.select("pi", "pizza")
    completion.select("pi", "pizza")
    completion.select("pi", "pizzicato")

    sug = completion.suggest("piz")
    assert_equal "pizzeria", sug[0]

    sug = completion.suggest("pi")
    assert_equal "pizza", sug[0]
    assert_equal "pizzicato", sug[1]
  end

  def test_it_can_prune_intermediate_nodes
    completion = CompleteMe.new
    completion.insert('trying')
    completion.insert('try')
  end

end
