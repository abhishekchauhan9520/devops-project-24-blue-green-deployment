FROM python:3.12-alpine
WORKDIR /app
COPY app/server.py .
EXPOSE 8080
ENV APP_VERSION=unknown
CMD ["python", "server.py"]
