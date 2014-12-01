### Learning Goals

* Build a Ruby class with instance methods.

### Instructions

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
Duration (min.): 41.45
Tracks:
- Bout My Bread
- Grindin Skit
- Drop It In Tha Bank
- Batter Up
- I Get Toe Up
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

albums = []

CSV.foreach('space_jams.csv', headers: true, header_converters: :symbol) do |row|
  track = row.to_hash
  album = albums.find { |a| a.id == track[:album_id] }

  # if the album hasn't been added to the albums array yet, add it
  if album.nil?
    album = Album.new(track[:album_id], track[:album_name], track[:artists])
    albums << album
  end

  # add the track to the album's @tracks instance variable
  album.tracks << track
end

# print out the summary for each album
albums.each do |album|
  puts album.summary
end
```

### Hints

If you're having trouble getting started, ignore the tracks to start. Build an `Album` class that has only `id`, `title`, and `artists` attributes, and a summary method that prints out just album name and artists:

  ```no-highlight
  Name: Space Jams
  Artist(s): Tony Wrecks
  ```

Then you can add a `tracks` attribute and populate each album's `@track`'s instance variable when you iterate through the tracks to create your `albums` hash.

Finally, you can write the `duration_min` method and modify your `summary` method to output duration and track information.

### Extra Challenge

You know what would be nice? If tracks were their own objects, instead of just hashes.

Add a `Track` class. A track should have the following attributes, with getter methods for each attribute:

- `album_id`
- `id` (`track_id` in the CSV)
- `title`
- `track_number`
- `duration_ms` (duration in milliseconds)

Change your `Album` class so that it's `@tracks` instance variable is an array of `Track` objects instead of an array of hashes.
