## CompleteMe

This is an implementation of autocomplete using a trie, from http://backend.turing.io/module1/projects/complete_me

I'm trying to incorporate Rake, Bundler (with a Gemfile) and SimpleCov. SimpleCov is brand new.


### Iteration 1
This uses a trie data structure, where each letter is a `Node`, and each `Node` has a hash of `letter -> Node`. I did this for quick lookup.

One optimization I added was to use the same array in a recursive call to `add_child`, rather than using many sub-arrays.

When searching for suggestions, I made recursive calls to `suggest_word`, and this creates a lot of Strings. I don't like this part, but haven't moved forward in optimizing it.

### Iteration 2
For weighted suggestions I added a second hash to the "valid" nodes - nodes that are actual words - structured as `search -> count`.
