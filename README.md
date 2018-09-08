## CompleteMe

This is an implementation of autocomplete using a trie, from http://backend.turing.io/module1/projects/complete_me

I'm trying to incorporate Rake, Bundler (with a Gemfile) and SimpleCov. SimpleCov is brand new.


### Iteration 1
This uses a trie data structure, where each letter is a `Node`, and each `Node` has a hash of `letter -> Node`. I did this for quick lookup.

One optimization I added was to use the same array in a recursive call to `add_child`, rather than using many sub-arrays.

When searching for suggestions, I made recursive calls to `suggest_word`, and this creates a lot of Strings. I don't like this part, but haven't moved forward in optimizing it.

### Iteration 2
For weighted suggestions I added a second hash to the "valid" nodes - nodes that are actual words - structured as `search -> count`.

This also required a refactoring so that the suggested words was a list of valid leaf nodes, each of which knew about its own word. I then got each word string from the node to return to a user.

### Iteration 3
In order to prune nodes, a node is going to need a link to its parent. If we remove a leaf node, we have to traverse parent nodes and remove the node's letter from the parent's children. Then if the parent's children is size zero, keep traversing.

I can't think of a good way to test this without exposing the nodes, both intermediate and valid.
