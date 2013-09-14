require './lib/webmention.rb'

# Send webmentions to any links on the page that have a webmention endpoint
url = 'http://aaronparecki.com/notes/2013/06/23/1/indiewebcamp'
client = Webmention::Client.new url
sent = client.send_mentions
puts "Sent #{sent} mentions"


# Discover the webmention endpoint of a target and send the mention
target = "http://indiewebcamp.com/"
endpoint = Webmention::Client.supports_webmention? target
if endpoint 
  Webmention::Client.send_mention endpoint, "http://source.example.com/post/100", target
end


# You can also use the client to send to a specific webmention endpoint
Webmention::Client.send_mention "http://webmention.io/example/webmention", "http://source.example.com/post/100", "http://target.example.com/post/100"

