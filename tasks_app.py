#!/usr/bin/env python3
"""Simple Japanese task manager GUI."""

from __future__ import annotations

import tkinter as tk
from tkinter import messagebox, ttk

from tasks import DEFAULT_STORE, add_task, clear_done, delete_task, list_tasks, mark_done


class TaskApp:
    def __init__(self, root: tk.Tk, store_path=DEFAULT_STORE) -> None:
        self.root = root
        self.store_path = store_path
        self.show_done = tk.BooleanVar(value=False)

        root.title("やることリスト")
        root.geometry("520x520")
        root.minsize(420, 420)

        style = ttk.Style()
        if "vista" in style.theme_names():
            style.theme_use("vista")

        self._build_ui()
        self.refresh_list()

    def _build_ui(self) -> None:
        header = ttk.Label(
            self.root,
            text="やることリスト",
            font=("Segoe UI", 18, "bold"),
        )
        header.pack(pady=(16, 8))

        help_text = ttk.Label(
            self.root,
            text="やることを入力して「追加する」を押してください",
            font=("Segoe UI", 10),
        )
        help_text.pack(pady=(0, 12))

        input_frame = ttk.Frame(self.root, padding=(16, 0))
        input_frame.pack(fill="x")

        self.entry = ttk.Entry(input_frame, font=("Segoe UI", 12))
        self.entry.pack(side="left", fill="x", expand=True, padx=(0, 8))
        self.entry.bind("<Return>", lambda _event: self.on_add())

        add_button = ttk.Button(input_frame, text="追加する", command=self.on_add)
        add_button.pack(side="left")

        options_frame = ttk.Frame(self.root, padding=(16, 12))
        options_frame.pack(fill="x")

        show_done_check = ttk.Checkbutton(
            options_frame,
            text="完了済みも表示",
            variable=self.show_done,
            command=self.refresh_list,
        )
        show_done_check.pack(side="left")

        list_frame = ttk.LabelFrame(
            self.root,
            text="タスク一覧",
            padding=(12, 8),
        )
        list_frame.pack(fill="both", expand=True, padx=16, pady=(0, 8))

        self.listbox = tk.Listbox(
            list_frame,
            font=("Segoe UI", 12),
            activestyle="dotbox",
            selectmode=tk.SINGLE,
            height=12,
        )
        self.listbox.pack(side="left", fill="both", expand=True)

        scrollbar = ttk.Scrollbar(list_frame, orient="vertical", command=self.listbox.yview)
        scrollbar.pack(side="right", fill="y")
        self.listbox.configure(yscrollcommand=scrollbar.set)

        button_frame = ttk.Frame(self.root, padding=(16, 8))
        button_frame.pack(fill="x")

        ttk.Button(button_frame, text="完了にする", command=self.on_done).pack(
            side="left", padx=(0, 8)
        )
        ttk.Button(button_frame, text="削除", command=self.on_delete).pack(
            side="left", padx=(0, 8)
        )
        ttk.Button(button_frame, text="完了済みを消す", command=self.on_clear_done).pack(
            side="left"
        )

        footer = ttk.Label(
            self.root,
            text="データはこの PC に保存されます",
            font=("Segoe UI", 9),
        )
        footer.pack(pady=(0, 12))

    def refresh_list(self) -> None:
        self.listbox.delete(0, tk.END)
        tasks = list_tasks(self.store_path, show_all=self.show_done.get())
        self.task_ids: list[int] = []

        if not tasks:
            self.listbox.insert(tk.END, "（タスクはありません）")
            return

        for task in tasks:
            prefix = "✓" if task.done else "・"
            due = f"  [期限: {task.due}]" if task.due else ""
            self.listbox.insert(tk.END, f"{prefix} {task.text}{due}")
            self.task_ids.append(task.id)

    def selected_task_id(self) -> int | None:
        selection = self.listbox.curselection()
        if not selection or not self.task_ids:
            return None
        index = selection[0]
        if index >= len(self.task_ids):
            return None
        return self.task_ids[index]

    def on_add(self) -> None:
        text = self.entry.get().strip()
        if not text:
            messagebox.showinfo("入力してください", "やることを入力してください。")
            return

        add_task(self.store_path, text)
        self.entry.delete(0, tk.END)
        self.refresh_list()

    def on_done(self) -> None:
        task_id = self.selected_task_id()
        if task_id is None:
            messagebox.showinfo("選択してください", "完了にするタスクを選んでください。")
            return

        mark_done(self.store_path, task_id)
        self.refresh_list()

    def on_delete(self) -> None:
        task_id = self.selected_task_id()
        if task_id is None:
            messagebox.showinfo("選択してください", "削除するタスクを選んでください。")
            return

        if messagebox.askyesno("削除の確認", "このタスクを削除しますか？"):
            delete_task(self.store_path, task_id)
            self.refresh_list()

    def on_clear_done(self) -> None:
        removed = clear_done(self.store_path)
        if removed == 0:
            messagebox.showinfo("お知らせ", "完了済みタスクはありません。")
        else:
            messagebox.showinfo("完了", f"完了済みタスクを {removed} 件削除しました。")
        self.refresh_list()


def main() -> None:
    root = tk.Tk()
    TaskApp(root)
    root.mainloop()


if __name__ == "__main__":
    main()
