from flask import Flask, jsonify, Response
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST, start_http_server, Summary

app = Flask(__name__)

REQUEST_COUNTER = Counter("http_requests_total", "Total HTTP Requests")

@app.route("/")
def hello_world():
    REQUEST_COUNTER.inc()
    return "<p>Hello from my simple flask app!</p>"


@app.route("/metrics")
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)

@app.route("/api/items")
def get_items():
    items = [
        {"id": 1, "name": "Item 1", "price": 11.70},
        {"id": 2, "name": "Item 2", "price": 99},
        {"id": 3, "name": "Item 3", "price": 7.3}
    ]
    return jsonify(items)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
