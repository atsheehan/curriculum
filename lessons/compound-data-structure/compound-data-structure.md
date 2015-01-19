### Instructions

The method `twitter_data` returns twitter usernames and relevant fields of those usernames. Write a program in `code.rb` that traverses through the compound data structure to print out some data in a particular format and answer a series of questions.

#### Write code to print out data in a particular format

* Each username followed by its description. If there is no description (i.e., `nil` then print out "NA" instead):

```no-highlight
LaunchAcademy_: A 10 week, intensive bootcamp teaching you how to code with a focus on Ruby on Rails
dpickett: Co-Founder at @LaunchAcademy_, Co-Organizer of @bostonrb
.
.
.
```

* Each username followed by total number of followers:

```no-highlight
LaunchAcademy_: 3590
dpickett: 1604
.
.
.
```

* Each username and the length of their latest tweet:

```no-highlight
LaunchAcademy_'s latest tweet was 140 characters long.
dpickett's latest tweet was 81 characters long.
.
.
.
```

* Each username followed by the total character count used in that user's last twenty tweets:

```no-highlight
LaunchAcademy_ used 2431 characters in their last twenty tweets.
dpickett used 2149 characters in their last twenty tweets.
.
.
.
```

*

#### Write code to answer the following questions

* Which user has the most followers?
* Which user has the most friends?
* Which user has the greatest number of tweets?
* Which users have a `description` listed in `@twitter_data`?
* Which users have a `location` listed in `@twitter_data`?

### Sample Usage

* What are the twitter usernames in `@twitter_data`?

```ruby
@twitter_data.each do |hash|
  puts hash.keys.first
end
```

#### Sample Output

```no-highlight
LaunchAcademy_
dpickett
STWatkins78
chrisccerami
spencercdixon
corinnebabbles
dot_the_speck
bostonrb
judngu
lizvdk
hchood
wand_chris
julissaJM
ashleytbasinger
alacritythief
```

### Tips

* Break down the compound data structure into its smallest parts. Isolate a data structure and ask yourself what composes it. Is it an array of hashes? An array of strings? An array of arrays?

* Reference the Ruby docs for [Arrays](http://www.ruby-doc.org/core-2.2.0/Array.html), [Hashes](http://www.ruby-doc.org/core-2.2.0/Hash.html) and [Strings](http://www.ruby-doc.org/core-2.2.0/String.html) to explore what methods Ruby has to offer.

* Use `.each`. Use it a lot.
