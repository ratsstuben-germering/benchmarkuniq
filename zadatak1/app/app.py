from flask import Flask, jsonify
import redis
import os

app = Flask(__name__)

redis_host = os.getenv("REDIS_HOST", "redis")
r = redis.Redis(host=redis_host, port=6379, db=0, decode_responses=True)

@app.route("/")
def visit():
    count = r.incr("counter")
    return jsonify({"visits": count})

@app.route("/reset")
def reset():
    r.set("counter", 0)
    return jsonify({"message": "Counter reset."})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
