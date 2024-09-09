# https://github.com/rabbitmq/rabbitmq-server/blob/main/deps/rabbit/docs/rabbitmq.conf.example
FROM rabbitmq:3.13.7-management AS rabbitmq

COPY --chown=rabbitmq:rabbitmq config /etc/rabbitmq/

HEALTHCHECK --interval=2s --timeout=20s --retries=10 CMD rabbitmq-diagnostics check_port_connectivity
