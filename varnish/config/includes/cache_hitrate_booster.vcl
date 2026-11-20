# Strip query strings only needed by browser javascript. Customize to used tags.
if (req.url ~ "(\?|&)(pk_campaign|piwik_campaign|pk_kwd|piwik_kwd|pk_keyword|pixelId|kwid|kw|adid|chl|dv|nk|pa|camid|adgid|cx|ie|cof|siteurl|utm_[a-z_]+|mtm_[a-z_]+|_ga|_gl|gtm_debug|_stg_debug|gclid|gbraid|wbraid|gad|gad_[a-z_]+|dclid|srsltid|ltclid|fbclid|msclkid|li_fat_id|hsa_[a-z]+|_hsenc|_hsmi|__hssc|__hstc|__hsfp|hsCtaTracking|submissionGuid)=") {
	set req.url = regsuball(req.url, "(?<=\?|&)(pk_campaign|piwik_campaign|pk_kwd|piwik_kwd|pk_keyword|pixelId|kwid|kw|adid|chl|dv|nk|pa|camid|adgid|cx|ie|cof|siteurl|utm_[a-z_]+|mtm_[a-z_]+|_ga|_gl|gtm_debug|_stg_debug|gclid|gbraid|wbraid|gad|gad_[a-z_]+|dclid|srsltid|ltclid|fbclid|msclkid|li_fat_id|hsa_[a-z]+|_hsenc|_hsmi|__hssc|__hstc|__hsfp|hsCtaTracking|submissionGuid)=[^&]*(&|$)", "");
}

# Normalize query arguments
set req.url = std.querysort(req.url);
