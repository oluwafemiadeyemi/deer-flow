FROM python:3.12-slim

WORKDIR /app

RUN pip install uv

COPY backend/ ./

RUN uv sync --frozen --no-dev 2>/dev/null || uv sync --no-dev 2>/dev/null || pip install .

EXPOSE 8024

CMD ["uv", "run", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8024"]
