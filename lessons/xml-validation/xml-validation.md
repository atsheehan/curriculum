### Learning Goals

* A _very_ brief introduction to Extensible Markup Language (XML)
* Understand what validating a document in a particular format entails
* Learn how to implement stacks and queues in Ruby

### What is XML?

Extensible Markup Language, or XML, is a text format designed for ease of use in electronic publishing and the exchanging of data through the Web. While similar to HTML in practice, the two differ in an important respect: XML is designed for the _description_ of data whereas HTML is designed for the _depiction_ of data on a web page.

#### What is valid XML?

Here is an example of a valid XML document:

```
<?xml version="1.0" encoding="UTF-8"?>
<note>
<to>Dr. Dre</to>
<from>Eminem</from>
<heading>I need a doctor</heading>
<body>I'm about to lose my mind</body>
</note>
```

In a valid XML document like the one above, opened tags have associated closing tags in the correct position. If a tag is missing or in the wrong order, the document is not valid XML format. Take a look at the following XML:

```
<?xml version="1.0" encoding="UTF-8"?>
<note>
<to>2Pac's Mother</to>
<from>2Pac</from>
<heading>Dear Mama</heading>
<body>Pour out some liquor and I reminsce, cause through the drama</body>
```

The missing `</note>` tag at the bottom of the following would result in an invalid XML file because the original `<note>` tag is never closed.

### Requirements

Write a program called `xml-validation.rb` that validates whether or not a document is valid XML. This challenge includes `MozartTrio.xml` which you can use to test your program.

#### Hint

Rubymonk has some great resources on implementing arrays as stacks and queues, which you might find helpful in this challenge:

http://rubymonk.com/learning/books/4-ruby-primer-ascent/chapters/33-advanced-arrays/lessons/86-stacks-and-queues




