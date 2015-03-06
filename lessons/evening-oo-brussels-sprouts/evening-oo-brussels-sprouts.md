##Objectify Those Brussels Sprouts Recipes!

###Learning Goals
* Create classes that have constructors
* Instantiate custom objects
* Use instance variables to persist constructor arguments

###Instructions

Write an `Ingredient` class. Initialize an ingredient object should involve the `name` of the ingredient and the `amount` (both of these are strings). The `Ingredient` class should have a method that returns a summary of the ingredient, like the following:

```ruby
ingredient = Ingredient.new("Brussels Sprouts", "47 lbs")
```

Running the above code in `pry` would produce something similar to the following:

```
=> #<Ingredient:0x007fa19bc29450 @name="Brussels Sprouts", @quantity="47 lbs">
```

Now, if we run `summary` on ingredient, we should receive the following output:

```ruby
puts ingredient.summary
=> "47 lbs: Brussels Sprouts"
```

Now, write a `Recipe` class. Creating a new `Recipe` object should involve taking in a `name`, an array of `instructions` and an array of `Ingredient` objects.

```
name = "Roasted Brussels Sprouts"

ingredients = [
    Ingredient.new("Brussels sprouts", "1 1/2 pounds"),
    Ingredient.new("Good olive oil", "3 tablespoons"),
    Ingredient.new("Kosher salt", "3/4 teaspoons"),
    Ingredient.new("Freshly ground black pepper",
    "1/2 teaspoon")
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
- 1 1/2 pounds: Brussels sprouts
- 3 tablespoons: Good olive oil
- 3/4 teaspoons: Kosher salt
- 1/2 teaspoon: Freshly ground black pepper

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
