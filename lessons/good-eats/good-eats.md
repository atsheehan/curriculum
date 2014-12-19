### Instructions

Create a Rails application that allows users to view restaurants. The application must satisfy the following criteria:

* A restaurant must have a name, address, city, state, and zip code. It can optionally have a description and a category (e.g. *thai*, *italian*, *chinese*).
* Visiting the `/restaurants` path should contain a list of restaurants.
* Visiting the `/restaurants/new` path should display a form for creating a new restaurant.
* Visiting the `/restaurants/10` path should show the restaurant details for a restaurant with ID = 10.
* Visiting the root path should display a list of all restaurants.

Once these criteria have been met, add the ability for users to review restaurants. The application must satisfy the following criteria:

* A restaurant can have many reviews. Each review must contain a rating between 1 and 5, a body, and a timestamp for when it was created.
* Visiting the `/restaurants/10/reviews/new` should display a form for creating a new review for a restaurant with ID = 10.
* Visiting the `/restaurants/10` path should also include all reviews for a restaurant with ID = 10.

For this challenge assume all restaurants and reviews are submitted anonymously (user authentication is **not** required). In addition, acceptance tests are **optional** but not required.

To get started, create a new Rails application with the following command:

```no-highlight
$ rails new good_eats --database=postgresql -T
```
