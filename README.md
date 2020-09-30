# URL Shortener

A project to practice some Elixir. The URL shortener will take a URL and shorten it to something like `https://short.ly/WnsXjZm4`. It has two endpoints

-   `/encode` - Encodes a URL to a shortened URL
-   `/decode` - Decodes a shortened URL to its original URL.

Both endpoints return JSON.

## Getting started

To get the project up and running:

```bash
# Install dependencies
$ mix deps.get

# Run webserver
$ mix run --no-halt
# Starting application on http://localhost:8080
```

After the server is up and running. Navigate to http://localhost.8080. You should see the text `I'm up` if the server is working.

## Encoding / Decoding a URL

To encode / decode a URL you will need to make a post call to `/encode` and `/decode` respectively.

Both POST calls expect a JSON body with the value:

```json
"url": "https://yoururlhere.com
```

Until, a form is built on the frontend. Postman is one such tool to make this POST request.

## Running tests

```bash
$ mix test
```

## Next steps
- Handle collisions
- Build front end
