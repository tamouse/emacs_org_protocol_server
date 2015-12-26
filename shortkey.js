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
