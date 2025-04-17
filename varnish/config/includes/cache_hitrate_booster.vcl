# Strip query strings only needed by browser javascript. Customize to used tags.
if (req.url ~ "(\?|&)(pk_campaign|piwik_campaign|pk_kwd|piwik_kwd|pk_keyword|pixelId|kwid|kw|adid|chl|dv|nk|pa|camid|adgid|cx|ie|cof|siteurl|utm_[a-z]+|_ga|_gl|gclid|ltclid|fbclid)=") {
	set req.url = regsuball(req.url, "(?<=\?|&)(pk_campaign|piwik_campaign|pk_kwd|piwik_kwd|pk_keyword|pixelId|kwid|kw|adid|chl|dv|nk|pa|camid|adgid|cx|ie|cof|siteurl|utm_[a-z]+|_ga|_gl|gclid|ltclid|fbclid)=[^&]*(&|$)", "");
}

# Normalize query arguments
set req.url = std.querysort(req.url);
