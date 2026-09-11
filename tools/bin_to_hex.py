from pathlib import Path
import sys

MEM_WORDS = 32

inp = Path(f"build/{sys.argv[1]}")
out = Path(f"programs/{sys.argv[2]}")

data = inp.read_bytes()

if len(data) % 4 != 0:
    raise ValueError("Binary size is not a multiple of 4 bytes")

words = []

for i in range(0, len(data), 4):
    word = int.from_bytes(data[i:i+4], byteorder="little")
    words.append(word)

if len(words) > MEM_WORDS:
    raise ValueError(f"Program too large: {len(words)} words, memory only has {MEM_WORDS}")

while len(words) < MEM_WORDS:
    words.append(0)

with out.open("w") as f:
    for word in words:
        f.write(f"{word:08x}\n")

print(f"Wrote {len(words)} words to {out}")
