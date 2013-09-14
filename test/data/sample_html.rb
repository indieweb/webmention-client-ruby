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

end
