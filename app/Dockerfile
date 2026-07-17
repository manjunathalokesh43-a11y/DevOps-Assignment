FROM python:3.11-slim

LABEL maintainer="Manjunatha"

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

ENV ENVIRONMENT=Development
ENV APP_NAME=Flask-App
ENV APP_VERSION=1.0

CMD ["gunicorn","--bind","0.0.0.0:5000","app:app"]