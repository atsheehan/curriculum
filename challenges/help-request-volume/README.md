CSVs are a common file format for storing logs and database dumps. Being able to efficiently process these files allows us to analyze that information and draw conclusions from the data. In this challenge we'll be analyzing a list of all help requests created at Launch Academy to determine when we've reached peak volume.

## Requirements

There are a few questions we want to be able to answer:

* How many help requests were generated on a given date?
* How many help requests were generated between two dates?
* What date had the highest volume of help requests?

We have a CSV containing a list of all help requests that were submitted since Launch Academy began (we only include the title and the date the help request was created). Using this data we should be able to write methods to answer the above questions:

```ruby
# Returns the number of help requests for the given date.
#
# * +filename+ is passed in as a string and is the path to the CSV file
#   containing the help requests.
# * +date+ is a string and represents the date to check for help requests.
#   It is in the format of YYYY-MM-DD (e.g. 2014-08-25).
def date_count(filename, date)
  # YOUR CODE HERE
end

# Returns the number of help requests for the given date range.
#
# * +filename+ is passed in as a string and is the path to the CSV file
#   containing the help requests.
# * +start_date+ is a string and represents the beginning of the date range.
# * +end_date+ is a string and represents the beginning of the date range.
#
#   Both +start_date+ and +end_date+ are in the format of YYYY-MM-DD.
def range_count(filename, start_date, end_date)
  # YOUR CODE HERE
end

# Returns the date containing the most help requests.
#
# * +filename+ is passed in as a string and is the path to the CSV file
#   containing the help requests.
def highest_volume(filename)
  # YOUR CODE HERE
end
```

## Example Usage

Once the above methods have been created, we should be able to utilize them as such:

```ruby
date_count("help_requests.csv", "2014-08-25")
#=> 14

range_count("help_requests.csv", "2014-01-01", "2014-04-01")
#=> 840

highest_volume("help_requests.csv")
#=> "2014-06-17"
```
