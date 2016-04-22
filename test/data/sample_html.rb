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

  def self.rel_webmention_a_href
    <<-eos
      <html>
        <head>
          <a rel="webmention" href="http://webmention.io/example/webmention">webmention</a>
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
        <body class="h-entry">
          <p><a href="http://target.example.com/post/4">Link to Target 4</a></p>
          <p><a href="http://target.example.com/post/5">Link to Target 5</a></p>
        </body>
      </html>
    eos
  end
  
  def self.rel_webmention_relative_with_path
    <<-eos
      <html>
        <head>
          <link href="/example/webmention" rel="webmention">
        </head>
      </html>
    eos
  end

  def self.rel_webmention_relative_without_path
    <<-eos
      <html>
        <head>
          <link href="webmention.php" rel="webmention">
        </head>
      </html>
    eos
  end
  
  def self.link_tag_multiple_rel_values
    <<-eos
      <html>
        <head>
          <link href="http://webmention.io/example/webmention" rel="webmention foo bar">
        </head>
      </html>
    eos
  end

end
