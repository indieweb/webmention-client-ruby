module TestFixtures
  REL_WEBMENTION_HREF = '
    <html>
      <head>
        <link rel="webmention" href="http://webmention.io/example/webmention">
      </head>
    </html>'.freeze

  SAMPLE_SOURCE_POST_HTML = '
    <html>
      <head>
        <title>Sample Post</title>
      </head>
      <body class="h-entry">
        <p><a href="http://target.example.com/post/4">Link to Target 4</a></p>
        <p><a href="http://target.example.com/post/5">Link to Target 5</a></p>
      </body>
    </html>'.freeze
end
