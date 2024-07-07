acl debug {
    "192.168.0.0"/16;
    "172.24.0.0"/16;
}

acl purge {
    "website_fpm";
    "website_cli";
    "website_cron";
}

acl webserver {
    "website_fpm";
    "website_cli";
    "website_cron";
}
