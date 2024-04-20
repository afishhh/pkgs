import re
from sys import argv
from pathlib import Path

regex = re.compile(
    "([.]{2}/)+nix/store/[A-z0-9]+?-patched-jakt-lsp-root(/[A-z0-9/.]*)?"
)
replacement = "(pkgs.callPackage ../patched-src.nix {})"

root = Path(argv[1])

for file in root.iterdir():
    pos = 0
    text = file.read_text()

    while True:
        m = regex.search(text, pos=pos)
        if m is None:
            break

        tail = m.group(2)
        plus = (" + " + tail) if tail else ""
        new = replacement + plus

        text = text[: m.start()] + new + text[m.end() :]
        pos = m.start() + len(new)

    file.write_text(text)


def find_line_index(text: str, line: int) -> int:
    idx = 0

    while line > 0:
        idx = text.index("\n", idx) + 1
        line -= 1

    return idx


# HACK: This is perfect... and it will break if node2nix ever decides to slightly change the contents of default.nix or node-packages.nix.
# NOTE: This can be removed once nix PR #6530 is merged.
np = root / "node-packages.nix"
text = np.read_text()

i = find_line_index(text, 2) + 1
text = text[:i] + "pkgs, " + text[i:]

np.write_text(text)

ne = root / "default.nix"
text = ne.read_text()

i = find_line_index(text, 15)
text = text[:i] + "inherit pkgs;" + text[i:]

ne.write_text(text)
