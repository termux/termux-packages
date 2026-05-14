# browser.py — left-panel file tree
import os

DIR_OPEN   = "▼ "
DIR_CLOSED = "▶ "
FILE_ICON  = "  "

SKIP_DIRS = frozenset({
    ".git", "__pycache__", ".idea", ".vscode",
    "node_modules", "venv", ".venv",
})

class TreeNode:
    __slots__ = ("path", "name", "is_dir", "depth", "expanded")
    def __init__(self, path, depth=0):
        self.path     = path
        self.name     = os.path.basename(path) or path
        self.depth    = depth
        self.is_dir   = os.path.isdir(path)
        self.expanded = (depth == 0)

class FileBrowser:
    def __init__(self, root):
        self.root        = os.path.abspath(root)
        self._root_node  = TreeNode(self.root, depth=0)
        self._children   = {}
        self._flat       = []
        self._selected   = 0
        self._scroll     = 0
        self._rebuild()

    def _load_children(self, node):
        if node.path in self._children:
            return
        try:
            raw = list(os.scandir(node.path))
        except PermissionError:
            self._children[node.path] = []
            return

        raw.sort(key=lambda e: (not e.is_dir(follow_symlinks=False), e.name.lower()))
        kids = []
        for entry in raw:
            if entry.name in SKIP_DIRS or entry.name.startswith("."):
                continue
            kids.append(TreeNode(entry.path, depth=node.depth + 1))
        self._children[node.path] = kids

    def _rebuild(self):
        self._flat = []
        self._walk(self._root_node)

    def _walk(self, node):
        self._flat.append(node)
        if node.is_dir and node.expanded:
            self._load_children(node)
            for child in self._children.get(node.path, []):
                self._walk(child)

    def move_up(self):
        self._selected = max(0, self._selected - 1)

    def move_down(self):
        self._selected = min(len(self._flat) - 1, self._selected + 1)

    def selected_node(self):
        return self._flat[self._selected] if 0 <= self._selected < len(self._flat) else None

    def toggle_selected(self):
        node = self.selected_node()
        if node is None: return None
        if node.is_dir:
            node.expanded = not node.expanded
            self._rebuild()
            return None
        return node.path

    def render(self, height):
        total = len(self._flat)
        if self._selected < self._scroll:
            self._scroll = self._selected
        elif self._selected >= self._scroll + height:
            self._scroll = self._selected - height + 1

        rows = []
        for i in range(self._scroll, min(self._scroll + height, total)):
            node = self._flat[i]
            indent = "  " * node.depth
            icon   = (DIR_OPEN if node.expanded else DIR_CLOSED) if node.is_dir else FILE_ICON
            rows.append((indent + icon + node.name, i == self._selected, node.is_dir))
        return rows
