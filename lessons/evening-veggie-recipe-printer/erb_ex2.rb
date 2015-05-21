require "erb"

message = "
  <% if 5 >= 0 %>
    Hello!
  <% else %>
    Goodbye!
  <% end %>
"
erb = ERB.new(message)

puts erb.result  # => "Hello!"
