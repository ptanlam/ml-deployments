# ml-deployment-basics

A hands-on exploration of two common approaches to deploying a machine learning model as an API.

The model used throughout is a text sentiment classifier (trained with scikit-learn) that predicts whether a given piece of text is positive or negative.

---

## Approach 1: Web Server (Flask)

**Directory:** `server/`

Run the model inside a long-lived Flask web server. The model is loaded into memory once at startup and reused for every request.

### How it works

- Flask app loads the model from a local `.joblib` file on startup
- Exposes a `POST /predict` endpoint
- Accepts a JSON body with an `x` field (list of strings to classify)
- Returns predictions as JSON

### Run locally

```bash
cd server
uv run python main.py
```

### Example request

```bash
curl -X POST http://localhost:8080/predict \
  -H "Content-Type: application/json" \
  -d '{"x": ["I hate Brokeback Mountain", "I love Brokeback Mountain"]}'
```

### Tradeoffs

| | |
|---|---|
| **Pros** | Simple to develop and debug locally; low latency (model stays in memory) |
| **Cons** | You manage the server, scaling, and uptime; idle server still costs money |

---

## Approach 2: Serverless (Google Cloud Functions)

**Directory:** `serverless/`

Deploy the model as a Google Cloud Function. There is no persistent server — the function spins up on demand, downloads the model from GCS, runs inference, and shuts down.

### How it works

- Cloud Function is triggered by HTTP
- On each `POST` request, downloads the requested model from a GCS bucket to `/tmp`
- Loads the model with `pickle` and runs prediction
- Supports selecting between three models via the `model` field: `DecisionClassifier`, `LinearSVC`, or `LogisticRegression` (default)

Infrastructure is managed with Terraform (`serverless/*.tf`).

### Example request

```bash
curl -X POST https://<your-function-url> \
  -H "Content-Type: application/json" \
  -d '{"model": "DecisionClassifier", "x": ["I hate Brokeback Mountain", "I love Brokeback Mountain"]}'
```

### Tradeoffs

| | |
|---|---|
| **Pros** | No server to manage; scales to zero (no idle cost); easy to deploy via Terraform |
| **Cons** | Cold start latency (model downloaded on each invocation); model/numpy versions must match between training and the function runtime |

---

## Project structure

```
server/         # Flask web server approach
  main.py
  pyproject.toml

serverless/     # Google Cloud Function approach
  function/
    main.py
    requirements.txt
  *.tf          # Terraform infrastructure

training/       # Model training code and saved artifacts
```
