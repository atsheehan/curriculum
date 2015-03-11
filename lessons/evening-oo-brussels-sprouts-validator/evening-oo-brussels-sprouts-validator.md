##OMG We Need to Validate Recipes!!

###Learning Goals
* Implement Class methods to check inputs

###Instructions
Your client is highly allergic to many foods and can only eat recipes that contain certain types of ingredients, which are the ones below:

```
brussels sprouts
spinach
eggs
milk
tofu
seitan
bell peppers
quinoa
kale
chocolate
beer
wine
whiskey
```

If a recipe contains any ingredients other than these, your client will have to be sent to the hospital. That would be bad, both for your client and for your career as a developer. So what can you do?

Update your code from last evening to include class methods that check for the following:

* Implement an instance method in your `Ingredient` class that helps check whether an ingredient is valid (i.e., contains only the ingredient names above)?
* Write a `Recipe` instance method that returns `true` or `false` dependent on whether or not your client can have that particular dish.
* What if your input to your `Ingredient` class comes in a different format? Write an `Ingredient` class method called `parse` which takes in a string that will look like `47 lb(s) Brussels sprouts` or `5 tspn(s) milk` and generates a variable of the `Ingredient` class in the right format.

###Output
Submit your updated code in `code.rb` and include some example cases (meaning, generate your own recipe with name, instructions and ingredients) and return your validations of these recipes (whether or not they fit the criteria in the instructions above).
