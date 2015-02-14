##The Amazing Vegetarian Recipe Printer!

###Instructions
Write a program that prints out recipes in a particular format using Ruby and [Embedded Ruby](http://ruby-doc.org/stdlib-2.2.0/libdoc/erb/rdoc/ERB.html) or `erb`. Your `.rb` file should contain the `recipe` variable below. The output of your code should follow the format noted below under `output`.

1. First produce the formatted output with plain Ruby.
2. Next produce the formatted output with `erb`. A short blog titled [Ruby's ERB Templating System](http://www.rrn.dk/rubys-erb-templating-system) could be helpful here.

###Learning Goals
* Utilizing a hash to print human readable format on the screen.
* Make use of Ruby's `erb` library to print out data in specific format.

###Input

```ruby
recipe = {
  name: "Roasted Brussel Sprouts",
  ingredients: [
    "1 1/2 pounds Brussels sprouts",
    "3 tablespoons good olive oil",
    "3/4 teaspoon kosher salt",
    "1/2 teaspoon freshly ground black pepper"
    ],
  directions: [
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
  }
```

###Output
```
#=================================#
# Recipe: Roasted Brussel Sprouts #
#=================================#

Ingredients
-----------

1 1/2 pounds Brussels sprouts
3 tablespoons good olive oil
3/4 teaspoon kosher salt
1/2 teaspoon freshly ground black pepper

Directions
----------

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
