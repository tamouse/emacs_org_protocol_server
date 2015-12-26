# Emacs Org-Protocol Server

Emacs's `org-protocol` module in `org-mode` can be used to accept an
`org-protocol://` scheme. However, configuring this on Mac OSX using
Chrome seems problematic. There is a utility called
[EmacsClient](https://github.com/neil-smithline-elisp/EmacsClient.app)
that is listed in the
[`org-protocol`](http://orgmode.org/worg/org-contrib/org-protocol.html#orgheadline6)
documentation, however, it does not work on 10.11.2 (El Capitan) as of
this writing (Sat Dec 26 04:42:59 2015). So I cam up with this
alternative, which uses a [Sinatra](http://www.sinatrarb.com)
mini-server running locally.

## Installation

Install the gem locally:

    gem install emacs-org-protocol-server

Start it up:

    emacs-org-protocol-server

This will run the server on port 4567, and call
`/usr/local/bin/emacsclient` to operate.

## Server Configuration

The server configuration is contained in the file `$HOME/.config/emacs_org_protocol_server.yml`, a standard YAML key-value pair file.

Example (defaults):

``` yaml
server: [thin, mongrel, webrick]
port: 4567
bind: 0.0.0.0
emacsclient: /usr/local/bin/emacsclient
```

You can also specify these via the environment, which will take precedence over the configuration file and the defaults:

``` bash
EMACS_ORG_PROTOCOL_CONFIG=./my_config.yml
EMACS_ORG_PROTOCOL_BIND=127.0.0.1
EMACS_ORG_PROTOCOL_PORT=9998
EMACS_ORT_PROTOCOL_SERVER=thin
EMACSCLIENT=/Application/Emacs.app/Content/MacOS/bin/emacsclient
```

## Browser Configuration

The entire point here is to get something from your browser over into
emacs. Our good emacs teacher,
[Sacha Chua](http://sachachua.com/)
has an article on
[Capturing links quickly with emacsclient, org-protocol, and Chrome Shortcut Manager on Microsoft Windows 8 - sacha chua  living an awesome life](http://sachachua.com/blog/2015/11/capturing-links-quickly-with-emacsclient-org-protocol-and-chrome-shortcut-manager-on-microsoft-windows-8/)
that helped me a lot in setting up my Chrome browser on OSX 10.11. I
still had to work out how it all worked, and build my own JavaScript
scriptlets and bookmarklets.

Essentially, you want to end up with a URL that calls the
`emacs-org-protocol-server` that looks like so:

    http://localhost:4567/?p=capture&l=http%3A%2F%2Fexample.com%2F&t=Example%20Domain&s=This%20domain%20is%20established%20to%20be%20used%20for%20illustrative%20examples%20in%20documents.%20You%20may%20use%20this%20domain%20in%20examples%20without%20prior%20coordination%20or%20asking%20for%20permission.

assuming your browser is sitting at `http://example.com`.

### ShortKeys

I wrote the following to put into a
[ShortKeys](https://chrome.google.com/webstore/detail/shortkeys-custom-keyboard/logpjaacgmcbpdkdchjiaagddngobkck?hl=en)
definition:

``` javascript
function fixedEncodeURIComponent (str) {
  return encodeURIComponent(str).replace(/[!'()*]/g, function(c) {
    return '%' + c.charCodeAt(0).toString(16);
  });
};

var captureLink = function(){
  var s = fixedEncodeURIComponent(window.getSelection().toString());
  var l = fixedEncodeURIComponent(window.location.href);
  var t = fixedEncodeURIComponent(document.title);
  var p = fixedEncodeURIComponent('capture')
  var uri = 'http://localhost:4567/?' +
	  'p=' + p +
      '&l=' + l +
      '&t=' + t +
      '&s=' + s
  window.location = uri;
  return uri;
};
captureLink();
```

Which is different from the code @sachac shows in her post.

In this case, URI encoding needs to go deeper than just the unsafe
characters, because you could easily have safe characters in any of
the components but you want
them  encoded anyway, such as `'`, `&`, etc.

Also, they are getting put together as a query string to the
`emacs-org-protocol-server` instead of the URI itself.

Copy and paste the into the Shortkeys javascript area when you're
creating your short key. You can assign
your own shortkey to it.

### Bookmarklet

Another way to do this, which is more what I'm used to, is to create a
JavaScript Bookmarklet. To do this in Chrome, you create a new
bookmark in your Bookmark Manager window, give it a name such as
`capture`, and then paste in some JS code prefixed by the pseudo-scheme
`javascript:`, for example:


``` javascript
javascript:function fx(str){return encodeURIComponent(str).replace(/[!'()*]/g, function(c){return '%' + c.charCodeAt(0).toString(16);});};var captureLink=function(){var s=fx(window.getSelection().toString()),l=fx(window.location.href),t=fx(document.title),p='capture',uri='http://localhost:4567/?'+'p='+p+'&l='+l+'&t='+t+'&s='+s;window.location=uri;return uri;};captureLink();
```

If you are running your `emacs-org-protocol-server` at a different
port than 4567, put that in the bookmarklet instead.

## Capture Template

The org-protocol capture sub-protocol theoretically lets you give a an
org-capture template code, but I'm still trying to get this to work
consistently and well. I've short-circuited the code in the server to
always use the "w" capture template (which is old behaviour) which
dumps the captured page information into my links journal file. You
can set up your own capture template, just name it "w".

Here's my "w" capture template:

``` elisp
("w"
 "Default Org-protocol Capture Template"
 entry
 (file+datetree (concat org-directory "link_journal.org"))
 "* %:link\n\n  Title: %:description\n\n  %?%:initial\n\n  captured at: %U\n"
 :empty-lines 1)

```

## Development

After checking out the repo, run `bin/setup` to install
dependencies. Then, run `rake` to run the tests. You can also run
`bin/console` for an interactive prompt that will allow you to
experiment. Run `bundle exec emacs_org_protocol_server` to use the gem
in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake
install`. To release a new version, update the version number in
`version.rb`, and then run `bundle exec rake release`, which will
create a git tag for the version, push git commits and tags, and push
the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/tamouse/emacs_org_protocol_server. This project
is intended to be a safe, welcoming space for collaboration, and
contributors are expected to adhere to the
[Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
