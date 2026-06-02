# Real-Time Customer Sentiment Dashboard

A Rails + Hotwire dashboard that simulates live customer reviews, classifies incoming text locally, and flags negative sentiment in real time with Turbo Streams and Action Cable.

## Features

- Live review feed with no page reloads using Turbo Streams over Action Cable.
- Simulator controls that enqueue review events continuously.
- Manual review ingestion for ad hoc testing.
- Local sentiment classification through `scripts/sentiment_classifier.py`.
- Hugging Face support when `transformers` and a cached model are available, with a deterministic lexical fallback for development.
- Real-time metrics, sentiment distribution, and negative-alert stream.

## Run

```sh
bundle install
bin/rails db:prepare
bin/rails server
```

Open `http://localhost:3000`.

On Windows PowerShell, run Rails through Ruby:

```powershell
bundle install
ruby bin\rails db:prepare
ruby bin\rails server
```

## Optional Hugging Face setup

The Python classifier first tries a local Hugging Face pipeline using `distilbert-base-uncased-finetuned-sst-2-english`. Install Python packages and cache the model locally if you want model-backed classification:

```sh
python -m pip install transformers torch
```

You can override the model:

```sh
HF_SENTIMENT_MODEL=distilbert-base-uncased-finetuned-sst-2-english bin/rails server
```

If Python, Transformers, Torch, or the local model is unavailable, the Rails service falls back to the built-in lexical classifier so the dashboard still works.
