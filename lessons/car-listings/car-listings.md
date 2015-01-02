### Instructions

You have been tasked with creating a system that manages cars in a used car lot. Create a Rails application that manages cars in a used car lot. The application must satisfy the following user stories:

```no-highlight
As a car salesperson
I want to record a car manufacturer
So that I can keep track of the types of cars found in the lot
```

Acceptance Criteria:

* I must specify a manufacturer name and country.
* If I do not specify the required information, I am presented with errors.
* If I specify the required information, the manufacturer is recorded and I am redirected to the index of manufacturers

```no-highlight
As a car salesperson
I want to record a newly acquired car
So that I can list it in my lot
```

Acceptance Criteria:

* I must specify the manufacturer, color, year, and mileage of the car (an association between the car and an existing manufacturer should be created).
* Only years from 1920 and above can be specified.
* I can optionally specify a description of the car.
* If I enter all of the required information in the required formats, the car is recorded and I am presented with a notification of success.
* If I do not specify all of the required information in the required formats, the car is not recorded and I am presented with errors.
* Upon successfully creating a car, I am redirected back to the index of cars.

### Notes

* User authentication is **not** required For this application.
* Utilize TDD to write tests for these behaviors.
* Make sure your tests pass.
* Make sure that your app is usable by providing links to navigate between the different pages.
* Make sure that your database has any necessary constraints.
* Make sure that your models contain any necessary validations and associations.
* Make sure that you don't commit code that isn't being used.
