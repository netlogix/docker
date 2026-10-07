vcl 4.1;

import std;
import xkey;
import cookie;

include "includes/imports.vcl";
include "includes/backends.vcl";
include "includes/acls.vcl";

sub vcl_recv {
    if (req.url == "/health") {
        return(synth(200, "health"));
    }

    # Handle PURGE
    if (req.method == "PURGE") {
        if (client.ip !~ purgers) {
            return (synth(403, "Forbidden"));
        }
        if (req.http.xkey) {
            set req.http.n-gone = xkey.purge(req.http.xkey);

            return (synth(200, "Invalidated "+req.http.n-gone+" objects"));
        } else {
            return (purge);
        }
    }

    if (req.method == "BAN") {
        if (!client.ip ~ purgers) {
            return (synth(403, "Forbidden"));
        }

        ban("req.url ~ "+req.url);
        return (synth(200, "BAN URLs containing (" + req.url + ") done."));
    }

    # Only handle relevant HTTP request methods
    if (req.method != "GET" &&
        req.method != "HEAD" &&
        req.method != "PUT" &&
        req.method != "POST" &&
        req.method != "PATCH" &&
        req.method != "TRACE" &&
        req.method != "OPTIONS" &&
        req.method != "DELETE") {
          return (pipe);
    }

    if (req.http.Authorization) {
        return (pass);
    }

    # We only deal with GET and HEAD by default
    if (req.method != "GET" && req.method != "HEAD") {
        return (pass);
    }

    # Always pass these paths directly to php without caching
    if (req.url ~  "^/(theme|media|thumbnail|bundles)/") {
        return (pass);
    }

    # Always pass these paths directly to php without caching
    if (req.url ~  "^/([a-z]{2}/)?(checkout|account|admin|api|store-api)(/.*)?$") {
        return (pass);
    }

    cookie.parse(req.http.cookie);

    set req.http.cache-hash = cookie.get("sw-cache-hash");
    set req.http.currency = cookie.get("sw-currency");
    set req.http.states = cookie.get("sw-states");

    if (req.url == "/widgets/checkout/info" && !req.http.states ~ "cart-filled") {
        return (synth(204, ""));
    }

    include "includes/cache_hitrate_booster.vcl";

    # Set a header announcing Surrogate Capability to the origin
    set req.http.Surrogate-Capability = "shopware=ESI/1.0";

    # Make sure that the client ip is forward to the client.
    if (req.http.x-forwarded-for) {
        set req.http.X-Forwarded-For = req.http.X-Forwarded-For + ", " + client.ip;
    } else {
        set req.http.X-Forwarded-For = client.ip;
    }

    include "includes/recv.vcl";

    return (hash);
}

sub vcl_hash {
    # Consider Shopware HTTP cache cookies
    if (req.http.cache-hash != "") {
        hash_data("+context=" + req.http.cache-hash);
    } elseif (req.http.currency != "") {
        hash_data("+currency=" + req.http.currency);
    }

    include "includes/hash.vcl";
}

sub vcl_hit {
  # Consider client states for response headers
  if (req.http.states) {
     if (req.http.states ~ "logged-in" && obj.http.sw-invalidation-states ~ "logged-in" ) {
        return (pass);
     }

     if (req.http.states ~ "cart-filled" && obj.http.sw-invalidation-states ~ "cart-filled" ) {
        return (pass);
     }
  }

  include "includes/hit.vcl";
}

sub vcl_backend_fetch {
    include "includes/backend_fetch.vcl";

    unset bereq.http.cache-hash;
    unset bereq.http.currency;
    unset bereq.http.states;

    # Varnish can only gunzip/re-gzip for ESI parsing, not brotli. Force the
    # backend to never respond with Content-Encoding: br, otherwise ESI tags
    # in the (opaque, br-compressed) body never get resolved.
    if (bereq.http.Accept-Encoding) {
        if (bereq.http.Accept-Encoding ~ "gzip") {
            set bereq.http.Accept-Encoding = "gzip";
        } else {
            unset bereq.http.Accept-Encoding;
        }
    }
}

sub vcl_backend_response {
    # how long stale objects may be served while re-validation happens
    set beresp.grace = 24h;

    # keep delivering the graced object instead of replacing it with a backend error
    if (beresp.status >= 500 && bereq.is_bgfetch) {
        return (abandon);
    }

    include "includes/backend_response_pre_cookie_unset.vcl";

    unset beresp.http.X-Powered-By;
    unset beresp.http.Server;

    if (beresp.http.Surrogate-Control ~ "ESI/1.0") {
        unset beresp.http.Surrogate-Control;
        set beresp.do_esi = true;
    }

    if (bereq.url ~ "\.js$" || beresp.http.content-type ~ "text") {
        set beresp.do_gzip = true;
    }

    if (beresp.ttl > 0s && (bereq.method == "GET" || bereq.method == "HEAD")) {
        unset beresp.http.Set-Cookie;
    }
}

sub vcl_deliver {
    include "includes/deliver.vcl";

    ## we don't want the client to cache
    if (resp.http.Cache-Control !~ "private" && req.url !~ "^/(theme|media|thumbnail|bundles)/") {
        set resp.http.Pragma = "no-cache";
        set resp.http.Expires = "-1";
        set resp.http.Cache-Control = "no-store, no-cache, must-revalidate, max-age=0";
    }

    if (std.ip(req.http.X-Client-Ip, client.ip) !~ debug) {
        # invalidation headers are only for internal use
        unset resp.http.sw-invalidation-states;
        unset resp.http.X-Varnish;
        unset resp.http.Via;
        unset resp.http.Link;
    } elseif (obj.hits > 0) {
        set resp.http.X-Cache = "HIT";
        set resp.http.X-Cache-Hits = obj.hits;
    } else {
        set resp.http.X-Cache = "MISS";
    }

    # Remove xkey header to prevent 502 nginx error because of too big header
    unset resp.http.xkey;
}
