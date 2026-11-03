FROM telegraf:1.40 AS telegraf

# Image defaults live in defaults.d; projects mount their own config into telegraf.d
# (whole directory or single files) and can replace a default by mounting over its file.
COPY defaults.d/ /etc/telegraf/defaults.d/

EXPOSE 9273

CMD ["telegraf", "--config-directory", "/etc/telegraf/defaults.d", "--config-directory", "/etc/telegraf/telegraf.d"]
