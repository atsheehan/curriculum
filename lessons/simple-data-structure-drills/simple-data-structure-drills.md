## Array Drills

Dr. Dre needs some help with his banking. Below is a list of his most recent transactions (deposits are positive and withdrawals are negative):

```ruby
transactions = [50_000, -2_000, -25_000, 4_000, -12_000, 5_000, -800, -900, 43_000, -30_000, 15_000, 62_000, -50_000, 42_000]
```

(Note: an `_` can be used like a comma when separating large numbers by three digits)

Write Ruby code to find out the answers to the following questions:

* What is the value of the first transaction?
* What is the value of the second transaction?
* What is the value of the fourth transaction?
* What is the value of the last transaction?
* What is the value of the second from last transaction?
* What is the value of the 5th from last transaction?
* What is the value of the transaction with index 5?
* How many transactions are there in total?
* How many positive transactions are there in total?
* How many negative transactions are there in total?
* What is the largest withdrawal?
* What is the largest deposit?
* What is the small withdrawal?
* What is the smallest deposit?
* What is the total value of all the transactions?
* If Dr. Dre's initial balance was $239,900 in this account, what is the value of his balance after his last transaction?

(Note: The [Ruby docs on Arrays](http://www.ruby-doc.org/core-2.2.0/Array.html) is a great resource for Ruby's Array data structure and its methods.)

## Hash Drills

```ruby
best_records = {
 "Tupac"=>"All Eyez on Me",
 "Eminem"=>"The Marshall Mathers LP",
 "Wu-Tang Clan"=>"Enter the Wu-Tang (36 Chambers)",
 "Led Zeppelin"=>"Physical Graffiti",
 "Metallica"=>"The Black Album",
 "Pink Floyd"=>"The Dark Side of the Moon",
 "Pearl Jam"=>"Ten",
 "Nirvana"=>"Nevermind"
 }
```

Write Ruby code to find out the answers to the following questions:

* How many records are in `best_records`?
* Who are all the artists listed?
* What are all the album names in the hash?
* Delete the `Eminem` key-value pair from the list.
* Add your favorite musician and their best album to the list.
* Change `Nirvana`'s album to another.
* Is `Nirvana` included in `best_records`?
* Is `Soundgarden` included in `best_records`?
* If `Soundgarden` is not in `best_records` then add a key-value pair for the band.
* Which key-value pairs have a key that has a length less than or equal to 6 characters?
* Which key-value pairs have a value that is greater than 10 characters?

(Note: The [Ruby docs on Hashes](http://www.ruby-doc.org/core-2.1.5/Hash.html is a great resource for Ruby's Hash data structure and its methods.)
