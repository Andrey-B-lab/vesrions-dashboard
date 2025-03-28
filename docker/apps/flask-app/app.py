from flask import Flask
import os

app = Flask(__name__)

@app.route("/")
def home():
    return "Flask App is running"

@app.route("/version")
def version():
    return os.environ.get("APP_VERSION", "unknown")

app.run(host="0.0.0.0", port=80)
