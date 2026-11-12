# https://github.com/rabbitmq/rabbitmq-server/blob/main/deps/rabbit/docs/rabbitmq.conf.example
FROM rabbitmq:4.4.0-management AS rabbitmq

COPY --chown=rabbitmq:rabbitmq config /etc/rabbitmq/

HEALTHCHECK --interval=30s --timeout=20s --start-period=60s --start-interval=2s --retries=3 CMD rabbitmq-diagnostics check_port_connectivity
