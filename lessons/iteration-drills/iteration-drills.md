Here we will drill iteration concepts using `.each` for arrays, hashes and compound data structures.

### Turning `.each` into English

*example*

```ruby
# cities is an array
cities.each do |city|
  puts city
end
```

*answer*
#
`For every element called 'city' in the array 'cities', print out 'city' `

Write English interpretations of the following Ruby code:

1.

```ruby
# numbers is an array
numbers.each do |number|
  puts 3 * number
end
```

2.

```ruby
# names is an array
names.each do |name|
  puts name.length
end
```

3.

```ruby
# numbers is an array
sum = 0
numbers.each do |number|
  sum += number
end
puts sum
```

4.

```ruby
# hash is a hash
hash.each do |name, age|
  puts "#{name} is #{age} years old."
end
```

5.

```ruby
# account is a hash
sum = 0
account.each do |transaction, value|
  sum += value
end
puts "The value the account is #{value}"
```

6.

```ruby
# addresses is a hash
addresses.each do |name, address|
  puts "#{name} lives on #{address}"
end
```

### Turning English into `.each`

*example*

`For every element 'number' in the array 'numbers' print out the number.`

*answer*

```ruby
numbers.each do |number|
  puts number
end
```

1. `For every element 'word' in the array 'sentences' print out the word.`

2. `For every element 'phone_number' in the array 'numbers' print out the phone number if it is a MA area code.`

3. `For every element number in the array 'numbers' print out every odd number.`

4. `For every name-age pair in the hash 'ages', print out each pair.`

5. `For every name-age pair in the hash 'ages', print out a pair if the age is > 10.`

6. `For every name-age pair in the hash 'ages', print out a pair if the age is even.`

### Arrays

#
1. Consider the following array:

```ruby
array = [28214, 63061, 49928, 98565, 31769, 42316, 23674, 3540, 34953, 70282, 22077, 94710, 50353, 17107, 73683, 33287, 44575, 83602, 33350, 46583]
```

Write Ruby code to find out the answers to the following questions:

* What is the sum of all the numbers in `array`?
* How would you print out each value of the array?
* What is the sum of all of the even numbers?
* What is the sum of all of the odd numbers?
* What is the sum of all the numbers divisble by 5?
* What is the sum of the squares of all the numbers in the array?

#
2. Consider the following array:

```ruby
array = ["joanie", "annamarie", "muriel", "drew", "reva", "belle", "amari", "aida", "kaylie", "monserrate", "jovan", "elian", "stuart", "maximo", "dennis", "zakary", "louvenia", "lew", "crawford", "caitlyn"]
```

Write Ruby code to find out the answers to the following questions:

* How would you print out each name backwards in `array`?
* What are the total number of characters in the names in `array`?
* How many names in `array` are less than 5 characters long?
* How many names in `array` end in a vowel?
* How many names in `array` are more than 5 characters long?
* How many names in `array` are exactly 5 characters in length?

### Hashes

#
1. Consider the following hash:

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

* How would you print out all the names of the artists?
* How would you print out all the names of the albums?
* Which artist has the longest name?
* How would you change all the album titles for every artist to `Greatest Hits`?
* How would you delete a key-value pair if the artist's name ends in a vowel?

#
2. Consider the following hash:

```ruby
ages = {"Arch"=>89, "Gretchen"=>93, "Simone"=>12, "Daija"=>96, "Alivia"=>22, "Serena"=>28, "Alek"=>3, "Lula"=>24, "Christian"=>62, "Darryl"=>47, "Otha"=>32, "Evalyn"=>44, "Lincoln"=>27, "Rebeca"=>99, "Beatrice"=>99, "Kelton"=>10, "Zachary"=>18, "Aurelie"=>91, "Dell"=>71, "Lisandro"=>22}
```

Write Ruby code to find out the answers to the following questions:

* How would you print out all the names of `ages`?
* How would you print out each key-value pair in the format of `<name> is <age> years old.`?
* How would you print out every person with odd numbered age?
* How would you delete everyone under 25 years of age?
* What is the name and age of everyone with a name greater than or equal to 5 characters?

### Compound Data Structures

Consider the following compound data structure:

#
1.

```ruby
people =
{
  "Alia O'Conner PhD" => {
         "phone" => "538.741.1841",
       "company" => "Leuschke-Stiedemann",
      "children" => [
          "Simone",
          "Cindy",
          "Jess"
      ]
  },
           "Ike Haag" => {
         "phone" => "(661) 663-8352",
       "company" => "Carter Inc",
      "children" => [
          "Joe",
          "Ofelia",
          "Deron"
      ]
  },
       "Brian Heller" => {
         "phone" => "1-288-601-5886",
       "company" => "O'Conner Group",
      "children" => [
          "Renee"
      ]
  },
       "Maryse Johns" => {
         "phone" => "218-571-8774",
       "company" => "Kuhlman Group",
      "children" => [
          "Dominick",
          "Tricia"
      ]
  },
  "Dr. Adela DuBuque" => {
        "phone" => "1-203-483-1226",
      "company" => "Heidenreich, Nietzsche and Dickinson"
  }
}
```

Write Ruby code to find out the answers to the following questions:

* How would you print out all the names of `people`?
* How would you print out all the names of `people` and which company they work for?
* What are the names of all the children of everyone in `people`?
* What are the names of all the companies that people work for?
* How would you convert all the phone numbers to the same standard (pick one)?

#
2.

Consider the following compound data structure:

```ruby
people =
[
    {
          "Derek Wehner" => {
               "phone" => "588-047-7782",
             "company" => "Daniel-Carroll",
            "children" => [
                "Phoebe",
                "Gretchen",
                "Wiley"
            ]
        },
           "Ali Koelpin" => {
               "phone" => "1-127-057-0020",
             "company" => "Rau, Rutherford and Lockman",
            "children" => [
                "Juwan"
            ]
        },
        "Ervin Prohaska" => {
               "phone" => "(393) 630-3354",
             "company" => "Carter Inc",
            "children" => [
                "Virgil",
                "Piper",
                "Josianne"
            ]
        },
          "Hellen Borer" => {
              "phone" => "1-687-825-0947",
            "company" => "Maggio, Ferry and Moen"
        }
    },
    {
        "Elinor Johnson" => {
              "phone" => "819.911.5553",
            "company" => "Pollich Group"
        }
    },
    {
        "Richmond Murray" => {
               "phone" => "1-516-432-2364",
             "company" => "Sporer and Sons",
            "children" => [
                "Kade",
                "Sage"
            ]
        },
            "Nakia Ferry" => {
               "phone" => "134-079-2237",
             "company" => "Hamill, O'Keefe and Lehner",
            "children" => [
                "Rollin"
            ]
        }
    }
]
```

Write Ruby code to find out the answers to the following questions:

* What are the names of everyone in `people`?
* What are the names of all the children in `people`?
* How would you create a new hash called `phone_numbers` that has a key of a name and value of a phone number in `people`?
* How would you create a new hash called `employers` that has a key of a name and a value of a company name in `people`?
* How would you create a new hash called `children_count` that has a key of a name and a value of the number of children a person has?



