module TestFixtures
  SAMPLE_POST_HTML = '
    <html>
      <head>
        <title>Sample Post</title>
      </head>
      <body class="h-entry">
        <p><a href="https://target.example.com/post/1">Link to Target 1</a></p>
        <p><a href="https://target.example.com/post/2">Link to Target 2</a></p>
        <p><img src="https://target.example.com/image.jpg" srcset="https://target.example.com/image-1x.jpg, https://target.example.com/image-2x.jpg 2x"></p>
      </body>
    </html>'.freeze
end
