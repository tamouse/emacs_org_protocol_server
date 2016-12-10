(function() {
    var fixEncoding = function(str) {
	return encodeURIComponent(str)
	    .replace(/[!'()*]/g, function(c) {
		return '%' +
		    c.charCodeAt(0)
		    .toString(16);
	    });
    };

    var location = window.location.href;
    if (location) {
	location = location.toString();
    } else {
	location = '';
    }

    var title = document.title;
    if (title) {
	title = title.toString();
    } else {
	title = '';
    }

    var selection = window.getSelection();
    if (selection) {
	selection = selection.toString();
    } else {
	selection = '';
    }

    var description = document.querySelector('meta[name=description]');
    if (description) {
	description = description.attributes.content.value.toString();
    } else {
	description = '';
    }

    var keywords = document.querySelector('meta[name=keywords]');
    if (keywords) {
	keywords.attributes.content.value.toString();
    } else {
	keywords = '';
    }

    var body = JSON.stringify({
	'selection': selection,
	'description': description,
	'keywords': keywords
    });

    var uri = 'http://localhost:9998/?' +
	'&l=' + fixEncoding(location) +
	'&t=' + fixEncoding(title) +
	'&b=' + fixEncoding(body);

    window.location = uri;
    return uri;
})();
