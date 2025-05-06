from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Hello from my simple flask app!</p>"


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
