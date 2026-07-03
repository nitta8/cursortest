import unittest

from textstats import count_stats, top_words


class TextStatsTests(unittest.TestCase):
    def test_count_stats_empty(self) -> None:
        self.assertEqual(
            count_stats(""),
            {"characters": 0, "lines": 0, "words": 0},
        )

    def test_count_stats_multiline(self) -> None:
        text = "hello world\nsecond line"
        self.assertEqual(
            count_stats(text),
            {"characters": len(text), "lines": 2, "words": 4},
        )

    def test_top_words_ignores_punctuation(self) -> None:
        text = "Hello, hello! World world world."
        self.assertEqual(
            top_words(text, limit=2),
            [("world", 3), ("hello", 2)],
        )


if __name__ == "__main__":
    unittest.main()
