from flask import Flask
import os

app = Flask(__name__)

@app.route("/")
def home():
    return f"""
    <h1>DevOps Assignment Successful!</h1>
    <h2>Application is running on Amazon EKS</h2>

    <p><b>Environment:</b> {os.getenv('ENVIRONMENT')}</p>

    <p><b>Application:</b> {os.getenv('APP_NAME')}</p>

    <p><b>Version:</b> {os.getenv('APP_VERSION')}</p>
    """

@app.route("/health")
def health():
    return {
        "status": "UP"
    }

@app.route("/ready")
def ready():
    return {
        "status": "READY"
    }

if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=5000
    )