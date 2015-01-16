### Instructions

Create a Rails application that lists Launch Academy schwag.

**Do not** consider authentication or authorization as part of the requirements below.

#### User Stories

##### Add a category

```no-highlight
As a user
I want to add a category
So that I can categorize products
```

Acceptance Criteria:

* I must specify a unique name

##### Seed categories

```no-highlight
As an admin of the site
I want to preseed categories
So that other users can add products with predetermined categories
```

Acceptance Criteria:

* After I run `rake db:seed`, the following categories should exist:
  * T-Shirts
  * Hoodies
  * Stickers
* If I run `rake db:seed` more than once, it should not attempt to duplicate categories, and it should not cause an error

##### Add a product

```no-highlight
As a user
I want to add a product
So that others can see how much it costs
```

Acceptance Criteria:

* I must specify a name of the product, a price, a category, and an optional description

##### List Products

```no-highlight
As a user
I want to view a list of products
So that I can see what products are available
```

Acceptance Criteria:

* I can see a list of products, their price, and their categories

#### Filter list by category

```no-highlight
As a user
I want to filter the list of products
So that I can focus on particular categories
```

Acceptance Criteria:

* I can see a list of category filters on the product listing
* If I select a filter, only products within that category should be displayed
