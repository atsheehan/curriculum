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
* Which users have a `description` listed in `twitter_data`?
* Which users have a `location` listed in `twitter_data`?

### Sample Usage

* What are the twitter usernames in `twitter_data`?

```ruby
twitter_data.each do |hash|
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


### Hint

Let's take a look at how you might parse through some of the data structure by looking at one of the hashes in `twitter_data`:

```ruby
hash =
{"LaunchAcademy_"=>
   {"description"=>
     "A 10 week, intensive bootcamp teaching you how to code with a focus on Ruby on Rails",
    "last twenty tweets"=>
     ["RT @chrisccerami: While learning web development I created a map of all of the shows @Screamales have played and damn @DonGiovanniRecs http…",
      "6 ways to quantify your code and why you need to do it: http://t.co/1WKtpo41tP by @kevinrcasey http://t.co/lulzPLTY8c",
      "Do more of what you want at work. How to create productive partnerships: http://t.co/QpYpHhHEid by @benvoss",
      "RT @Pistachio: SO rad. bunch of local women learning to code with @gdiBoston at @HubSpot right now: http://t.co/jaIxK7suOj",
      "RT @STWatkins78: Huge breakthrough on my breakable toy today...can upload local file to soundcloud from my app...time for a beer! #LaunchAc…",
      "Just say yes to opportunities, especially if they scare you. http://t.co/LcF2ilwKDu great advice by @kerry_benjamin1",
      "How the internet is changing software and business, using Ruby as an example: http://t.co/EMYeLa0se7 by  @ukitazume http://t.co/wNymPXcvAr",
      "RT @chrisccerami: @JustusEapen @LaunchAcademy_ @MarsCuriosity https://t.co/W6IBpIuIr0",
      "Come build some interesting projects! @womenwhocode Hack Night tomorrow. RSVP: http://t.co/wPgaQfQjVp http://t.co/sI5lIn9bJ9",
      "RT @SpencerCDixon: One of the greatest parts of being a developer is the massive amount of control you have over a computer. Feels very emp…",
      "7 reasons to love Minitest for testing Ruby code: http://t.co/Qbq5Wtb3RC by @FluxusFrequency, a graduate from our friends @gschool",
      "Interested in becoming a game developer? Here's how: http://t.co/xDJDzzFxA8 via @skilledup http://t.co/ir4GphhU3m",
      "Web developer hiring trends, and what they mean for you: http://t.co/0Ajg7TdQFm by @walesmd http://t.co/coRokF42kA",
      "RT @chrisccerami: I recently built my first API in Rails which I hope makes photos from Mars courtesy of @MarsCuriosity more accessible to …",
      "Build things that last. Make sure your work lives beyond you. http://t.co/YMbuOwhY36 by @acolangelo",
      "Thanks to everyone who came to Ship It! Saturday! Check out the latest blog post for a recap: http://t.co/EYSeUc87qQ http://t.co/pAG5x0GzTa",
      "Write your code as if your best friend's inheriting it http://t.co/kbtLURrPcN by @MGraybosch http://t.co/JesBAjwIiB",
      "Coding can improve the way we run the world. Old, but inspiring TED talk by @pahlkadot: http://t.co/mu7QqTZK6L http://t.co/Qol943YcX3",
      "Practicing pitches and getting ready for Career Day, coming up on January 27th and 28th! http://t.co/fxCcFIIMTc",
      "RT @lizvdk: The cool kids use GEOjson so I did too. Here's how I build it with Ruby: https://t.co/sXFTW9nzWb"],
    "number of followers"=>3590,
    "number of friends"=>699,
    "latest tweet"=>
     "RT @chrisccerami: While learning web development I created a map of all of the shows @Screamales have played and damn @DonGiovanniRecs http…",
    "number of tweets"=>1433,
    "location"=>"Boston, MA"}}
```

* How would I find the description of `LaunchAcademy_` in `hash`? First, I want to isolate `LaunchAcademy_`:

```ruby
hash["LaunchAcademy_"]
=> {"description"=>"A 10 week, intensive bootcamp teaching you how to code with a focus on Ruby on Rails",
 "last twenty tweets"=>
  ["RT @chrisccerami: While learning web development I created a map of all of the shows @Screamales have played and damn @DonGiovanniRecs http…",
   "6 ways to quantify your code and why you need to do it: http://t.co/1WKtpo41tP by @kevinrcasey http://t.co/lulzPLTY8c",
   "Do more of what you want at work. How to create productive partnerships: http://t.co/QpYpHhHEid by @benvoss",
   "RT @Pistachio: SO rad. bunch of local women learning to code with @gdiBoston at @HubSpot right now: http://t.co/jaIxK7suOj",
   "RT @STWatkins78: Huge breakthrough on my breakable toy today...can upload local file to soundcloud from my app...time for a beer! #LaunchAc…",
   "Just say yes to opportunities, especially if they scare you. http://t.co/LcF2ilwKDu great advice by @kerry_benjamin1",
   "How the internet is changing software and business, using Ruby as an example: http://t.co/EMYeLa0se7 by  @ukitazume http://t.co/wNymPXcvAr",
   "RT @chrisccerami: @JustusEapen @LaunchAcademy_ @MarsCuriosity https://t.co/W6IBpIuIr0",
   "Come build some interesting projects! @womenwhocode Hack Night tomorrow. RSVP: http://t.co/wPgaQfQjVp http://t.co/sI5lIn9bJ9",
   "RT @SpencerCDixon: One of the greatest parts of being a developer is the massive amount of control you have over a computer. Feels very emp…",
   "7 reasons to love Minitest for testing Ruby code: http://t.co/Qbq5Wtb3RC by @FluxusFrequency, a graduate from our friends @gschool",
   "Interested in becoming a game developer? Here's how: http://t.co/xDJDzzFxA8 via @skilledup http://t.co/ir4GphhU3m",
   "Web developer hiring trends, and what they mean for you: http://t.co/0Ajg7TdQFm by @walesmd http://t.co/coRokF42kA",
   "RT @chrisccerami: I recently built my first API in Rails which I hope makes photos from Mars courtesy of @MarsCuriosity more accessible to …",
   "Build things that last. Make sure your work lives beyond you. http://t.co/YMbuOwhY36 by @acolangelo",
   "Thanks to everyone who came to Ship It! Saturday! Check out the latest blog post for a recap: http://t.co/EYSeUc87qQ http://t.co/pAG5x0GzTa",
   "Write your code as if your best friend's inheriting it http://t.co/kbtLURrPcN by @MGraybosch http://t.co/JesBAjwIiB",
   "Coding can improve the way we run the world. Old, but inspiring TED talk by @pahlkadot: http://t.co/mu7QqTZK6L http://t.co/Qol943YcX3",
   "Practicing pitches and getting ready for Career Day, coming up on January 27th and 28th! http://t.co/fxCcFIIMTc",
   "RT @lizvdk: The cool kids use GEOjson so I did too. Here's how I build it with Ruby: https://t.co/sXFTW9nzWb"],
 "number of followers"=>3590,
 "number of friends"=>699,
 "latest tweet"=>"RT @chrisccerami: While learning web development I created a map of all of the shows @Screamales have played and damn @DonGiovanniRecs http…",
 "number of tweets"=>1433,
 "location"=>"Boston, MA"}
 ```

I can then isolate `description` further to get the description as follows:

```ruby
hash["LaunchAcademy_"]["description"]
=> "A 10 week, intensive bootcamp teaching you how to code with a focus on Ruby on Rails"
```

* If that's how I find the description, how do I find the number of followers of `LaunchAcademy_`?

```ruby
hash["LaunchAcademy_"]["number of followers"]
=> 3590
```

* What about the number of tweets?

```ruby
hash["LaunchAcademy_"]["number of tweets"]
=> 1433
```

See the pattern? Isolate what you need by isolating what's around it. Breaking up problems is the golden standard of a good programmer.
