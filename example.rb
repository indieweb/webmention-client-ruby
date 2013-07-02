require './lib/webmention.rb'

url = 'http://aaronparecki.com/notes/2013/06/23/1/indiewebcamp'

client = Webmention::Client.new url
sent = client.send_supported_mentions

puts "Sent #{sent} mentions"
