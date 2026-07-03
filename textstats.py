#!/usr/bin/env python3
"""Simple text statistics CLI for Cursor + GitHub + Python demo."""

from __future__ import annotations

import argparse
import sys
from collections import Counter


def count_stats(text: str) -> dict[str, int]:
    """Return basic statistics for the given text."""
    lines = text.splitlines()
    words = text.split()
    return {
        "characters": len(text),
        "lines": len(lines) if text else 0,
        "words": len(words),
    }


def top_words(text: str, limit: int = 5) -> list[tuple[str, int]]:
    """Return the most common words, ignoring case and punctuation."""
    normalized = [
        word.strip(".,!?;:\"'()[]{}").lower()
        for word in text.split()
        if word.strip(".,!?;:\"'()[]{}")
    ]
    return Counter(normalized).most_common(limit)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Count characters, lines, and words in text."
    )
    parser.add_argument(
        "text",
        nargs="?",
        help="Text to analyze. If omitted, reads from stdin.",
    )
    parser.add_argument(
        "--top",
        type=int,
        default=0,
        help="Show top N frequent words.",
    )
    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)

    text = args.text if args.text is not None else sys.stdin.read()
    stats = count_stats(text)

    print(f"characters: {stats['characters']}")
    print(f"lines: {stats['lines']}")
    print(f"words: {stats['words']}")

    if args.top > 0:
        print("top words:")
        for word, count in top_words(text, args.top):
            print(f"  {word}: {count}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
