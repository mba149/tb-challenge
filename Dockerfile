# === Stage 1: Build dependencies ===
FROM python:3.13.2-slim AS builder

# # Install system packages needed to build wheels
# RUN apt-get update && apt-get install -y --no-install-recommends gcc

# Set workdir
WORKDIR /app

# Copy requirements and install to temp dir
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --prefix=/install --no-cache-dir -r requirements.txt

# === Stage 2: Final image ===
FROM python:3.13.2-slim

# Add non-root user
RUN addgroup --system app && adduser --system --ingroup app appuser

WORKDIR /app

# Copy built dependencies from builder
COPY --from=builder /install /usr/local

# Copy your source code
COPY . .

# Set permissions
RUN chown -R appuser:app /app

USER appuser

EXPOSE 8000

CMD ["python", "hello.py"]
