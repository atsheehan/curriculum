###Learning Goals
* Create classes that have constructors
* Instantiate custom objects
* Use instance variables to persist constructor arguments

###Instructions

Write an `Ingredient` class. Initialize an ingredient object should involve a `quantity` (float), `unit` (string) and `name` (string) of the ingredient. The `Ingredient` class should have a method that returns a summary of the ingredient, like the following:

```ruby
ingredient = Ingredient.new(47.0, "lb(s)", "Brussels Sprouts")
```

Now, if we run `summary` on ingredient, we should receive the following output:

```ruby
puts ingredient.summary
=> "47.0 lb(s) Brussels Sprouts"
```

Write a `Recipe` class. Creating a new `Recipe` object should involve taking in a `name`, an array of `instructions` and an array of `Ingredient` objects.

```
name = "Roasted Brussels Sprouts"

ingredients = [
    Ingredient.new(1.5, "lb(s)", "Brussels sprouts"),
    Ingredient.new(3.0, "tbspn(s)", "Good olive oil"),
    Ingredient.new(0.75, "tspn(s)", "Kosher salt"),
    Ingredient.new(0.5, "tspn(s)", "Freshly ground black pepper")
]

instructions = [
    "Preheat oven to 400 degrees F.",
    "Cut off the brown ends of the Brussels sprouts.",
    "Pull off any yellow outer leaves.",
    "Mix them in a bowl with the olive oil, salt and pepper.",
    "Pour them on a sheet pan and roast for 35 to 40 minutes.",
    "They should be until crisp on the outside and tender on the inside.",
    "Shake the pan from time to time to brown the sprouts evenly.",
    "Sprinkle with more kosher salt ( I like these salty like French fries).",
    "Serve and enjoy!"
    ]
```

Additionally, write the Ruby code to generate the following output:

```ruby
recipe = Recipe.new(name, instructions, ingredients)
puts recipe.summary
```

That would result in the following output:

```
Name: Roasted Brussels Sprouts

Ingredients
- 1.5 lb(s) Brussels sprouts
- 3.0 tbspn(s) Good olive oil
- 0.75 tspn(s) Kosher salt
- 0.5 teaspoon(s) Freshly ground black pepper

Instructions
1. Preheat oven to 400 degrees F.
2. Cut off the brown ends of the Brussels sprouts.
3. Pull off any yellow outer leaves.
4. Mix them in a bowl with the olive oil, salt and pepper.
5. Pour them on a sheet pan and roast for 35 to 40 minutes.
6. They should be until crisp on the outside and tender on the inside.
7. Shake the pan from time to time to brown the sprouts evenly.
8. Sprinkle with more kosher salt ( I like these salty like French fries).
9. Serve and enjoy!
```

###Output
Write your classes in `code.rb` and include some example cases (meaning, generate your own recipe with name, instructions and ingredients) and print them out using the `summary` method.
