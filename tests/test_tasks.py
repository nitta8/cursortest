import tempfile
import unittest
from pathlib import Path

from tasks import add_task, clear_done, delete_task, list_tasks, load_tasks, mark_done


class TaskManagerTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temp_dir = tempfile.TemporaryDirectory()
        self.store = Path(self.temp_dir.name) / "tasks.json"

    def tearDown(self) -> None:
        self.temp_dir.cleanup()

    def test_add_and_list_tasks(self) -> None:
        add_task(self.store, "buy milk")
        add_task(self.store, "write report", due="2026-07-10")

        tasks = list_tasks(self.store)
        self.assertEqual(len(tasks), 2)
        self.assertEqual(tasks[0].text, "buy milk")
        self.assertEqual(tasks[1].due, "2026-07-10")

    def test_mark_done_hides_from_default_list(self) -> None:
        add_task(self.store, "task one")
        add_task(self.store, "task two")
        mark_done(self.store, 1)

        active = list_tasks(self.store)
        all_tasks = list_tasks(self.store, show_all=True)

        self.assertEqual(len(active), 1)
        self.assertEqual(active[0].id, 2)
        self.assertTrue(all_tasks[0].done)

    def test_delete_and_clear_done(self) -> None:
        add_task(self.store, "temporary")
        add_task(self.store, "keep")
        mark_done(self.store, 1)

        delete_task(self.store, 2)
        self.assertEqual(len(load_tasks(self.store)), 1)

        removed = clear_done(self.store)
        self.assertEqual(removed, 1)
        self.assertEqual(load_tasks(self.store), [])


if __name__ == "__main__":
    unittest.main()
