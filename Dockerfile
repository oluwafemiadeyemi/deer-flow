FROM python:3.12-slim

ARG NODE_MAJOR=22

RUN apt-get update && apt-get install -y \
    curl build-essential gnupg ca-certificates \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
       -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] \
       https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" \
       > /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:0.7.20 /uv /uvx /usr/local/bin/

WORKDIR /app
COPY backend ./backend
COPY config.example.yaml ./config.yaml

RUN cd backend && uv sync

EXPOSE 8001

CMD ["sh", "-c", "cd backend && PYTHONPATH=. uv run uvicorn app.gateway.app:app --host 0.0.0.0 --port 8001"]
