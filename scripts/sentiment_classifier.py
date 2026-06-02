import json
import os
import re
import sys


POSITIVE_WORDS = {
    "excellent",
    "fantastic",
    "smooth",
    "helpful",
    "patient",
    "quick",
    "quickly",
    "fixed",
    "love",
    "great",
    "good",
    "reliable",
    "happy",
}

NEGATIVE_WORDS = {
    "angry",
    "anxious",
    "broken",
    "damaged",
    "deleted",
    "disappointed",
    "failing",
    "frustrated",
    "furious",
    "ignored",
    "issue",
    "late",
    "poor",
    "refund",
    "timeout",
    "warning",
}

EMOTION_WORDS = {
    "anger": {"angry", "furious", "ignored", "broken", "refund"},
    "frustration": {"frustrated", "failing", "timeout", "repeated", "issue"},
    "anxiety": {"anxious", "confusing", "warning", "delayed"},
    "disappointment": {"disappointed", "damaged", "deleted", "poor", "late"},
    "satisfaction": {"excellent", "fantastic", "smooth", "helpful", "fixed", "love", "great", "happy"},
}


def lexical_result(text):
    tokens = re.findall(r"[a-z']+", text.lower())
    positive_hits = sum(1 for token in tokens if token in POSITIVE_WORDS)
    negative_hits = sum(1 for token in tokens if token in NEGATIVE_WORDS)
    raw_score = positive_hits - negative_hits

    if raw_score < 0:
        sentiment = "negative"
    elif raw_score > 0:
        sentiment = "positive"
    else:
        sentiment = "neutral"

    confidence = min(max(0.55 + abs(raw_score) * 0.08, 0.55), 0.98)
    raw_emotions = {
        emotion: sum(1 for token in tokens if token in words)
        for emotion, words in EMOTION_WORDS.items()
    }
    max_value = max(max(raw_emotions.values()), 1)
    emotions = {emotion: round(value / max_value, 2) for emotion, value in raw_emotions.items()}

    return {
        "sentiment": sentiment,
        "score": round(confidence, 3),
        "emotions": emotions,
        "flagged": sentiment == "negative",
    }


def hugging_face_result(text):
    try:
        from transformers import pipeline
    except Exception:
        return None

    model_name = os.environ.get(
        "HF_SENTIMENT_MODEL",
        "distilbert-base-uncased-finetuned-sst-2-english",
    )

    try:
        classifier = pipeline("sentiment-analysis", model=model_name)
        result = classifier(text[:512])[0]
    except Exception:
        return None

    label = result.get("label", "NEUTRAL").lower()
    if "neg" in label:
        sentiment = "negative"
    elif "pos" in label:
        sentiment = "positive"
    else:
        sentiment = "neutral"

    lexical = lexical_result(text)
    return {
        "sentiment": sentiment,
        "score": round(float(result.get("score", 0.55)), 3),
        "emotions": lexical["emotions"],
        "flagged": sentiment == "negative",
    }


def main():
    raw_input = sys.stdin.buffer.read().decode("utf-8-sig")
    payload = json.loads(raw_input or "{}")
    text = payload.get("text", "")
    result = hugging_face_result(text) or lexical_result(text)
    sys.stdout.write(json.dumps(result))


if __name__ == "__main__":
    main()
