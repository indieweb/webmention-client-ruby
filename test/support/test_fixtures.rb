module TestFixtures
  SAMPLE_POST_HTML = '
    <html>
      <head>
        <title>Sample Post</title>
      </head>
      <body>
        <header>
          <a href="/home" rel="home">Hello, world!</a>
        </header>
        <main class="h-entry">
          <p><a href="https://target.example.com/post/1">Link to Target 1</a></p>
          <p><a href="https://target.example.com/post/2">Link to Target 2</a></p>
          <p><a href="https://target.example.com/post/2">Duplicate Link to Target 2</a></p>
          <p><img src="https://target.example.com/image.jpg" srcset="https://target.example.com/image-1x.jpg, https://target.example.com/image-2x.jpg 2x"></p>
        </main>
      </body>
    </html>'.freeze

  SAMPLE_POST_HTML_ANCHORS_ONLY = '
    <html>
      <head>
        <title>Sample Post</title>
      </head>
      <body>
        <header>
          <a href="/home" rel="home">Hello, world!</a>
        </header>
        <main class="h-entry">
          <p><a href="https://target.example.com/post/1">Link to Target 1</a></p>
          <p><a href="https://target.example.com/post/2">Link to Target 2</a></p>
          <p><a href="/post/1">Relative Link to Source 1</a></p>
        </main>
      </body>
    </html>'.freeze

  SAMPLE_POST_HTML_NO_LINKS = '
    <html>
      <head>
        <title>Sample Post</title>
      </head>
      <body>
        <main class="h-entry">
          <p>Hello, world!</p>
        </main>
      </body>
    </html>'.freeze
end
