#!/bin/sh

set -e

ME=$(basename $0)

init_redirect_files() {
  local template_dir="/etc/nginx/redirects"

  mkdir -p "$template_dir"
  if [ ! -e "$template_dir/domains-to-urls.conf" ]; then
    touch "$template_dir/domains-to-urls.conf"
    echo >&3 "$ME: Create redirects file domains-to-urls.conf"
  fi

  if [ ! -e "$template_dir/$DOMAIN.conf" ]; then
    touch "$template_dir/$DOMAIN.conf"
    echo >&3 "$ME: Create redirects file $DOMAIN.conf"
  fi

}

init_redirect_files

exit 0
