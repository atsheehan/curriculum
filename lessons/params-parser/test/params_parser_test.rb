require_relative "../lib/params_parser"

RSpec.describe "params_parser" do
  let(:routes) do
    [
      ["GET", "/"],
      ["GET", "/toasters"],
      ["GET", "/toasters/new"],
      ["GET", "/toasters/:toaster_id"],
      ["GET", "/users/sign_in"],
      ["POST", "/toasters"],
      ["POST", "/users/sign_in"]
    ]
  end

  describe "GET requests" do
    it "extracts the method and path for the appropriate route" do
      request = <<EOS
GET / HTTP/1.1
Host: www.example.com

EOS

      results = params_parser(request, routes)

      expect(results[:method]).to eq("GET")
      expect(results[:path]).to eq("/")
    end

    it "returns nil if no match is found" do
      request = <<EOS
GET /waffle-makers HTTP/1.1
Host: www.example.com

EOS
      results = params_parser(request, routes)

      expect(results).to eq(nil)
    end

    it "extracts request headers" do
      request = <<EOS
GET /toasters HTTP/1.1
Host: www.example.com
Connection: keep-alive
Referer: http://news.ycombinator.com

EOS

      results = params_parser(request, routes)

      expect(results[:headers]["Host"]).to eq("www.example.com")
      expect(results[:headers]["Connection"]).to eq("keep-alive")
      expect(results[:headers]["Referer"]).to eq("http://news.ycombinator.com")
    end

    it "chooses the earlier match when multiple available" do
      request = <<EOS
GET /toasters/new HTTP/1.1
Host: www.example.com

EOS
      results = params_parser(request, routes)

      expect(results[:method]).to eq("GET")
      expect(results[:path]).to eq("/toasters/new")
    end

    it "extracts a parameter from the path" do
      request = <<EOS
GET /toasters/42 HTTP/1.1
Host: www.example.com

EOS
      results = params_parser(request, routes)

      expect(results[:method]).to eq("GET")
      expect(results[:path]).to eq("/toasters/42")
      expect(results[:params]["toaster_id"]).to eq("42")
    end

    it "extracts a parameter from the query string" do
      request = <<EOS
GET /toasters?page=2 HTTP/1.1
Host: www.example.com

EOS
      results = params_parser(request, routes)

      expect(results[:method]).to eq("GET")
      expect(results[:path]).to eq("/toasters")
      expect(results[:params]["page"]).to eq("2")
    end
  end

  describe "POST requests" do
    it "extracts the method and path for the appropriate route" do
      request = <<EOS
POST /toasters HTTP/1.1
Host: www.example.com
Content-Length: 11

hello=there

EOS
      results = params_parser(request, routes)

      expect(results[:method]).to eq("POST")
      expect(results[:path]).to eq("/toasters")
    end

    it "extracts a single parameter from the request body" do
      request = <<EOS
POST /toasters HTTP/1.1
Host: www.example.com
Content-Length: 11

hello=there

EOS
      results = params_parser(request, routes)

      expect(results[:params]["hello"]).to eq("there")
    end

    it "extracts multiple parameters from the request body" do
      request = <<EOS
POST /toasters HTTP/1.1
Host: www.example.com
Content-Length: 21

hello=there&name=bobo

EOS
      results = params_parser(request, routes)

      expect(results[:params]["hello"]).to eq("there")
      expect(results[:params]["name"]).to eq("bobo")
    end

    it "url-decodes any request parameters" do
      request = <<EOS
POST /toasters HTTP/1.1
Host: www.example.com
Content-Length: 72

brand=Hamilton%20Beach&model=22791%20Modern%20Chrome%202-Slice%20Toaster

EOS
      results = params_parser(request, routes)

      expect(results[:params]["brand"]).to eq("Hamilton Beach")
      expect(results[:params]["model"]).to eq("22791 Modern Chrome 2-Slice Toaster")
    end
  end
end
