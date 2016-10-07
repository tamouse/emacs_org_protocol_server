function fixEncoding(str) {
  return encodeURIComponent(str)
    .replace(/[!'()*]/g,
      function(c) {
        return '%' +
          c.charCodeAt(0)
            .toString(16);
      }
    );
}

var captureLink = function() {
  var selection = window.getSelection().toString();
  var location = window.location.href;
  var title = document.title;
  var description = document.querySelector('meta[name=description]');
  var keywords = document.querySelector('meta[name=keywords]');
  var protocol = 'capture';

  if (description) {
    description = description.attributes.content.value.toString()
  }

  if (keywords) {
    keywords.attributes.content.value.toString()
  }

  var uri = 'http://localhost:9998/?' +
    'p=' + protocol +
    '&l=' + fixEncoding(location) +
    '&t=' + fixEncoding(title) +
    '&s=' + fixEncoding("description: " + description + "\n\n" + "selection: " + selection + "\n\n")

  window.location = uri;
  return uri;
};

captureLink();
