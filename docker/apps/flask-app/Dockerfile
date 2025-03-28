FROM python:3.9-alpine
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
ENV APP_VERSION="dev"
CMD ["python", "app.py"]
