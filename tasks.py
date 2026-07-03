#!/usr/bin/env python3
"""Simple task manager CLI with local JSON storage."""

from __future__ import annotations

import argparse
import json
import sys
from dataclasses import asdict, dataclass
from datetime import date, datetime, timezone
from pathlib import Path
from typing import Any


DEFAULT_STORE = Path.home() / ".cursortest_tasks.json"


@dataclass
class Task:
    id: int
    text: str
    done: bool = False
    created_at: str = ""
    due: str | None = None

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> Task:
        return cls(
            id=data["id"],
            text=data["text"],
            done=data.get("done", False),
            created_at=data.get("created_at", ""),
            due=data.get("due"),
        )


def load_tasks(path: Path) -> list[Task]:
    if not path.exists():
        return []
    data = json.loads(path.read_text(encoding="utf-8"))
    return [Task.from_dict(item) for item in data]


def save_tasks(path: Path, tasks: list[Task]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    payload = [asdict(task) for task in tasks]
    path.write_text(
        json.dumps(payload, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )


def next_id(tasks: list[Task]) -> int:
    if not tasks:
        return 1
    return max(task.id for task in tasks) + 1


def validate_due(value: str) -> str:
    date.fromisoformat(value)
    return value


def add_task(path: Path, text: str, due: str | None = None) -> Task:
    tasks = load_tasks(path)
    task = Task(
        id=next_id(tasks),
        text=text.strip(),
        created_at=datetime.now(timezone.utc).isoformat(),
        due=due,
    )
    tasks.append(task)
    save_tasks(path, tasks)
    return task


def list_tasks(path: Path, show_all: bool = False) -> list[Task]:
    tasks = load_tasks(path)
    if show_all:
        return tasks
    return [task for task in tasks if not task.done]


def mark_done(path: Path, task_id: int) -> Task:
    tasks = load_tasks(path)
    for task in tasks:
        if task.id == task_id:
            task.done = True
            save_tasks(path, tasks)
            return task
    raise ValueError(f"task not found: {task_id}")


def delete_task(path: Path, task_id: int) -> Task:
    tasks = load_tasks(path)
    for index, task in enumerate(tasks):
        if task.id == task_id:
            removed = tasks.pop(index)
            save_tasks(path, tasks)
            return removed
    raise ValueError(f"task not found: {task_id}")


def clear_done(path: Path) -> int:
    tasks = load_tasks(path)
    remaining = [task for task in tasks if not task.done]
    removed = len(tasks) - len(remaining)
    save_tasks(path, remaining)
    return removed


def format_task(task: Task) -> str:
    status = "x" if task.done else " "
    due = f" (due: {task.due})" if task.due else ""
    return f"[{status}] {task.id}. {task.text}{due}"


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Manage daily tasks stored in a local JSON file."
    )
    parser.add_argument(
        "--file",
        type=Path,
        default=DEFAULT_STORE,
        help=f"Task storage file (default: {DEFAULT_STORE})",
    )

    subparsers = parser.add_subparsers(dest="command", required=True)

    add_parser = subparsers.add_parser("add", help="Add a new task")
    add_parser.add_argument("text", help="Task description")
    add_parser.add_argument("--due", type=validate_due, help="Due date (YYYY-MM-DD)")

    list_parser = subparsers.add_parser("list", help="List tasks")
    list_parser.add_argument(
        "--all",
        action="store_true",
        help="Include completed tasks",
    )

    done_parser = subparsers.add_parser("done", help="Mark a task as done")
    done_parser.add_argument("id", type=int, help="Task ID")

    delete_parser = subparsers.add_parser("delete", help="Delete a task")
    delete_parser.add_argument("id", type=int, help="Task ID")

    subparsers.add_parser("clear-done", help="Remove all completed tasks")

    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    path: Path = args.file

    try:
        if args.command == "add":
            task = add_task(path, args.text, args.due)
            print(f"added: {format_task(task)}")
        elif args.command == "list":
            tasks = list_tasks(path, show_all=args.all)
            if not tasks:
                print("no tasks")
            else:
                for task in tasks:
                    print(format_task(task))
        elif args.command == "done":
            task = mark_done(path, args.id)
            print(f"done: {format_task(task)}")
        elif args.command == "delete":
            task = delete_task(path, args.id)
            print(f"deleted: {format_task(task)}")
        elif args.command == "clear-done":
            count = clear_done(path)
            print(f"removed {count} completed task(s)")
    except ValueError as error:
        print(f"error: {error}", file=sys.stderr)
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
