from flask import Flask, render_template
import socket
from datetime import datetime
from prometheus_client import start_http_server, Counter

app = Flask(__name__)

# Prometheus metric
REQUEST_COUNT = Counter('request_count', 'Total number of requests')

@app.route("/")
def home():
    REQUEST_COUNT.inc()
    hostname = socket.gethostname()
    time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return render_template("index.html", hostname=hostname, time=time)

if __name__ == "__main__":
    # Start Prometheus metrics server
    start_http_server(8000)

    app.run(host="0.0.0.0", port=5000)