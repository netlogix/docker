if (req.restarts == 0
        && req.http.Cache-Control ~ "no-cache"
        && std.getenv("VARNISH_CACHE_REFRESH_SECRET") ~ "."
        && "0x" + cookie.get("nlx-cache-refresh") == digest.hmac_sha256(std.getenv("VARNISH_CACHE_REFRESH_SECRET"), "nlx-cache-refresh")) {
    set req.http.X-Restart-After-Purge = "1";
    return (purge);
}
