# hardened_malloc (pleme-io fork)

> **★★★ CSE / Knowable Construction.** This repo operates under **Constructive Substrate Engineering** — canonical specification at [`pleme-io/theory/CONSTRUCTIVE-SUBSTRATE-ENGINEERING.md`](https://github.com/pleme-io/theory/blob/main/CONSTRUCTIVE-SUBSTRATE-ENGINEERING.md). The Compounding Directive (operational rules: solve once, load-bearing fixes only, idiom-first, models stay current, direction beats velocity) is in the org-level pleme-io/CLAUDE.md ★★★ section. Read both before non-trivial changes.


GrapheneOS hardened memory allocator. Eliminates use-after-free exploits
via slab-based design with separate metadata region. Supports ARM MTE.

## Build

```bash
make                     # default variant
make VARIANT=light       # light variant (more compatible)
nix build .#default      # via Nix
nix build .#light        # light variant via Nix
```

## Upstream

Forked from [GrapheneOS/hardened_malloc](https://github.com/GrapheneOS/hardened_malloc).
MIT license. Sync upstream: `git fetch upstream && git merge upstream/main`.

## Integration

- Used as `LD_PRELOAD=/path/to/libhardened_malloc.so` for any Linux binary
- Integrated into Android's Bionic libc for system-wide protection
- Two variants: `default` (maximum security) and `light` (better compatibility)
