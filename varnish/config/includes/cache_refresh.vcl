sub nlx_cache_refresh {
    unset req.http.X-Restart-After-Purge;
    if (req.restarts == 0
            && req.http.Cache-Control ~ "no-cache"
            && std.getenv("VARNISH_CACHE_REFRESH_SECRET") ~ "."
            && cookie.get("nlx-cache-refresh") ~ "^[0-9]{10}:0x[0-9a-f]{64}$") {
        # Cookie-Format: timestamp:hash
        set req.http.X-NLX-Timestamp = regsub(cookie.get("nlx-cache-refresh"), ":.*$", "");
        if (std.integer(req.http.X-NLX-Timestamp, 0) <= std.integer(time=now)
                && std.integer(req.http.X-NLX-Timestamp, 0) > std.integer(time=now) - 3600
                && regsub(cookie.get("nlx-cache-refresh"), "^[^:]*:", "")
                    == digest.hmac_sha256(std.getenv("VARNISH_CACHE_REFRESH_SECRET"), "nlx-cache-refresh:" + req.http.X-NLX-Timestamp)) {
            set req.http.X-Restart-After-Purge = "1";
        }
        unset req.http.X-NLX-Timestamp;

        if (req.http.X-Restart-After-Purge) {
            return (purge);
        }
    }
}

sub vcl_purge {
    if (req.http.X-Restart-After-Purge) {
        return (restart);
    }
}
