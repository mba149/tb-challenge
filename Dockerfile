FROM python:3.13.2-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --prefix=/install --no-cache-dir -r requirements.txt

FROM python:3.13.2-slim
RUN addgroup --system app && adduser --system --ingroup app appuser
WORKDIR /app
COPY --from=builder /install /usr/local
COPY . .
RUN chown -R appuser:app /app
USER appuser
EXPOSE 8000

CMD ["python", "hello.py"]
