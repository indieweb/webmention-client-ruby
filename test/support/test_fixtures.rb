class SampleData
  def self.rel_webmention_href
    <<-eos
      <html>
        <head>
          <link rel="webmention" href="http://webmention.io/example/webmention">
        </head>
      </html>
    eos
  end

  def self.sample_source_post_html
    <<-eos
      <html>
        <head>
          <title>Sample Post</title>
        </head>
        <body class="h-entry">
          <p><a href="http://target.example.com/post/4">Link to Target 4</a></p>
          <p><a href="http://target.example.com/post/5">Link to Target 5</a></p>
        </body>
      </html>
    eos
  end
end
