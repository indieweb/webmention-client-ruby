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

  def self.rel_href_webmention
    <<-eos
      <html>
        <head>
          <link href="http://webmention.io/example/webmention" rel="webmention">
        </head>
      </html>
    eos
  end

  def self.rel_webmention_org_href
    <<-eos
      <html>
        <head>
          <link rel="http://webmention.org" href="http://webmention.io/example/webmention">
        </head>
      </html>
    eos
  end

  def self.rel_href_webmention_org
    <<-eos
      <html>
        <head>
          <link href="http://webmention.io/example/webmention" rel="http://webmention.org">
        </head>
      </html>
    eos
  end

  def self.rel_webmention_org_slash_href
    <<-eos
      <html>
        <head>
          <link rel="http://webmention.org/" href="http://webmention.io/example/webmention">
        </head>
      </html>
    eos
  end

  def self.rel_href_webmention_org_slash
    <<-eos
      <html>
        <head>
          <link href="http://webmention.io/example/webmention" rel="http://webmention.org/">
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
        <body>
          <p><a href="http://target.example.com/post/4">Link to Target 4</a></p>
          <p><a href="http://target.example.com/post/5">Link to Target 5</a></p>
        </body>
      </html>
    eos
  end

end
