# -----------------------------------
# Giai đoạn 1: Build environment
# -----------------------------------
FROM python:3.10-slim as builder

WORKDIR /app

# Cài đặt hệ thống phụ thuộc
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Cài đặt Poetry và quản lý dependencies
ENV POETRY_VERSION=1.7.0 \
    POETRY_HOME=/opt/poetry
RUN python3 -m venv $POETRY_HOME && \
    $POETRY_HOME/bin/pip install poetry==$POETRY_VERSION

COPY pyproject.toml poetry.lock ./
RUN $POETRY_HOME/bin/poetry export -f requirements.txt --output requirements.txt --without-hashes && \
    $POETRY_HOME/bin/pip install --user -r requirements.txt

# -----------------------------------
# Giai đoạn 2: Runtime environment
# -----------------------------------
FROM python:3.10-slim as runtime

WORKDIR /app

# Sao chép các dependencies đã build
COPY --from=builder /root/.local /root/.local
COPY --from=builder /app/requirements.txt .

# Cấu hình môi trường
ENV PATH=/root/.local/bin:$PATH \
    PYTHONPATH=/app \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Cập nhật các gói hệ thống và làm sạch cache
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Sao chép mã nguồn
COPY . .

# Thiết lập user không có quyền root
RUN groupadd -r appuser && \
    useradd -r -g appuser appuser && \
    chown -R appuser:appuser /app
USER appuser

EXPOSE 8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
