##OMG We Need Emergency Brussels Sprouts!!

We have run out of Brussels sprouts! A recent drought in the West Coast has caused a market downturn in our favorite ingredient. This is a problem.

Luckily, we have contacts in Belgium that can send us an emergency shipments of Brussels sprouts. We have requisitioned a special [Concorde](http://en.wikipedia.org/wiki/Concorde) airplane for speed of delivery.

###Learning Goals
* Understanding the concept of Class Composition
* Implement methods to achieve desired calculations

###Instructions

Write `Airplane`, `Container` and `Ingredient` classes to help answer the following questions:

* How many total Brussels sprouts can be carried in a Concorde based on the following requirements? How many Brussels Sprouts containers are needed for that?:
  * 5,000 lbs of Cheesy Poofs must be delivered
  * 1,000 lbs of Cheesy Poofs must be delivered

Here are your assumptions:
* The Concorde has a maximum carrying capacity (max cargo weight) of 20,000 lbs.
* We have to share our cargo with someone else who wants [Cheesy Poofs](https://www.youtube.com/watch?v=-XlYj1iyAlk).
* Each ingredient has a name and weight
  * A single Brussels sprout weighs 20 grams.
  * A single Cheesy Poof weighs 0.5 grams.
* Each container has a type of ingredient that it can carry and a quantity of ingredients
  * Each container can only carry one type of ingredient
  * Brussels sprouts friendly containers weigh 200 lbs and can carry a maximum weight of 300 lbs
  * Cheese Poof containers weigh 50 lbs and can carry a maximum weight of 20 lbs (they are very sturdy).

* Do not worry about dimensions of the plane and whether or not containers would physically fit. Just assume that they will.
* Do not worry about fuel.

###Output
Submit your updated code in `code.rb` and include some example cases. Adjust some of the assumptions and show us how the answers to the above questions change (i.e., what if we decide to send a 747 or a 787, instead).
