Webmention Client
=================

A Ruby gem for sending [webmention](http://indiewebcamp.com/webmention) (and [pingback](http://indiewebcamp.com/pingback)) notifications.

[![Build Status](https://travis-ci.org/icco/mention-client-ruby.png?branch=master)](https://travis-ci.org/icco/mention-client-ruby)

Installation
------------

    gem install webmention


Usage
-----

### Send webmentions to all links on a page

```ruby
client = Webmention::Client.new url
sent = client.send_mentions

puts "Sent #{sent} mentions"
```

This will find all absolute links on the page at `url` and will attempt to send
mentions to each. This is accomplished by doing a HEAD request and looking at the headers
for supported servers, if none are found, then it searches the body of the page.

After finding either webmention or pingback endpoints, the request is sent to each.

### Send webmention to a specific URL

```ruby
# Discover the webmention endpoint of a target and send the mention

source = "http://source.example.com/post/100"   # For example, your page
target = "http://indiewebcamp.com/"             # The page you linked to

if endpoint = Webmention::Client.supports_webmention?(target)
  Webmention::Client.send_mention endpoint, source, target
end
```


Webmention
----------

To learn more about Webmention, see [webmention.org](http://webmention.org).


License
-------

Copyright 2013 by Aaron Parecki

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
