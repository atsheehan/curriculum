# Amazon Orders

You have a serious online shopping addiction and order way too much stuff on Amazon.  You need an app to track your Amazon orders so your friends can stage an intervention. Your app should have an `Order` class representing each online order you place, and an `Item` class representing an item on an order.

## Instructions

### Item class

Create an `Item` class that represents each item on an order.  It should contain the following methods:

* `name` returns the name of the item.
* `description` returns a description of the item, if the item has a description.
* `manufacturer` returns the manufacturer of the item.
* `price` returns the price of the item.
* `summary` returns a summary of information about the item that looks like this:

```no-highlight
Name: Magnifying Glass
Description: Great for inspecting clues.
Manufacturer: Spys-R-Us
Price: $5.75
```

### Order class

Create an `Order` class to represent your Amazon order.  It should have the following methods:

* `customer` returns the name of the customer who placed the order.
* `placed_at` returns the date and time the order was placed.
* `payment_method` returns the type of payment (credit, debit, or PayPal, for example)
* `shipping_address` returns the shipping address (a string including the street address, city, state, and zip code).
* `items` returns an array of the items on the order (each of which should be an `Item` object).
* `total` returns the total cost of the items on the order.
* `summary` returns a summary of information about the order.  It should look something like this:

```no-highlight
Date: 12/10/2014
Customer: Gene Parmesan
Payment method: PayPal
Shipping address: 100 Spy Street, Newport Beach, CA 92625

Items:

Name: Magnifying Glass
Description: Great for inspecting clues.
Manufacturer: Spys-R-Us
Price: $5.75

Name: Spy Notebook
Description: Great for writing down clues.
Manufacturer: Spys-R-Us
Price: $10.50

Name: Detective Hat
Description: Great for looking like Sherlock Holmes.
Manufacturer: Private Investigator Suppliers
Price: $19.95

Total: $36.20
```

## Setup

Placeholders for both classes can be found in lib/item.rb and lib/order.rb. A test suite for the two classes has been supplied and can be run with the following command:

```no-highlight
$ rspec spec
```
