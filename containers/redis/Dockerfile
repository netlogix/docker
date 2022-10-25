# syntax=docker/dockerfile:1
FROM redis:7.0.5-alpine

HEALTHCHECK --interval=2s --timeout=20s --retries=10 CMD redis-cli ping
