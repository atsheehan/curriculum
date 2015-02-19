def params_parser(request, routes)
  # `routes` is an array of routes for a web application. Each route is an
  # array of length 2 that contains the method and path e.g.
  #
  # routes = [
  #   ["GET", "/"],
  #   ["GET", "/widgets"],
  #   ["GET", "/widgets/:id"],
  #   ["POST", "/widgets"]
  # ]
  #
  # `request` is a string containing the raw HTTP request e.g.
  #
  # GET / HTTP/1.1
  # Host: www.example.com

  # The expected return value is a Hash containing information extracted from
  # the request. The information to extract includes the method, path, headers,
  # and any params found in the path, query string, or request body e.g.
  #
  # GET /widgets/30?page=2 HTTP/1.1
  # Host: www.example.com
  #
  # Should return the following:
  #
  # {
  #   method: "GET",
  #   path: "/widgets/30",
  #   headers: { "Host" => "www.example.com" },
  #   params: { "page" => "2" }
  # }

  # YOUR CODE HERE
end
