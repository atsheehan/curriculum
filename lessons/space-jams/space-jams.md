# Learning Goals

* Build your first Ruby class and instance methods.

# Instructions

You've got a list of tracks in the `space_jams.csv` file. You want to print out summary information about each album in the CSV. Create an `Album` class with some methods that'll help you do that.

Your `Album` class should have the following instance methods:

* `id` - returns the ID of the album
* `title` - returns the title of the album
* `artists` - returns the name of the artist(s) on the album
* `tracks` - returns an array of hashes representing each track on the album
* `duration_min` - returns the duration of the album in minutes (`duration_ms` in the CSV is duration in milliseconds)
* `summary` - returns a string of summary information about the album in the following format:

```no-highlight
Name: Space Jams
Artist(s): Tony Wrecks
Duration (min.): 43.99
Tracks:
- Bout My Bread
- Grindin Skit
- Drop It In Tha Bank
- Batter Up
- I Get Toe Up
- Dat Nigga
- My Drop
- Heavyweights
- Preapproved - Freestyle
- Soldiers
- Don't Wanna See Me
- Lookin Clean
- One For Tha Money
- Toe Up Slowed And Chopped
- Swagger Up Slowed And Chopped
```

Create a `runner.rb` file that reads in the tracks from the CSV, creates a new `Album` object for each album in the data, and prints out the summary for each album:

```ruby
# runner.rb

require 'csv'
require_relative 'album'

# load in the tracks from the CSV
tracks = []

CSV.foreach('space_jams.csv', headers: true, header_converters: :symbol) do |row|
  tracks << row.to_hash
end

# create a hash of albums, using the album ID as the key and the Album object as the value
albums = {}

tracks.each do |track|
  # add the album to the albums hash if it's not yet in the albums hash
end

# print out the summary for each album
albums.each do |id, album|
  puts album.summary
end
```

## Hints

If you're having trouble getting started, ignore the tracks to start. Build an `Album` class that has only `id`, `title`, and `artists` attributes, and a summary method that prints out just album name and artists:

  ```no-highlight
  Name: Space Jams
  Artist(s): Tony Wrecks
  ```

Then you can add a `tracks` attribute and populate each album's `@track`'s instance variable when you iterate through the tracks to create your `albums` hash.

Finally, you can write the `duration_min` method and modify your `summary` method to output duration and track information.

## Extra Challenge

You know what would be nice? If tracks were their own objects, instead of just hashes.

Add a `Track` class. A track should have the following attributes, with getter methods for each attribute:

- `album_id`
- `id` (`track_id` in the CSV)
- `title`
- `track_number`
- `duration_ms` (duration in milliseconds)

Change your `Album` class so that it's `@tracks` instance variable is an array of `Track` objects instead of an array of hashes.

