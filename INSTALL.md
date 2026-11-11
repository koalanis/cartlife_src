# Install / Run

## Play the original release

The playable build is in `cartlife/Compiled/Compiled.rar`. One way to run it is with [ScummVM](https://www.scummvm.org/) (2.5 or later):

1. Install ScummVM, e.g. `winget install ScummVM.ScummVM` on Windows.
2. Extract `cartlife/Compiled/Compiled.rar` to a folder outside the repo, e.g. with 7-Zip.
3. In ScummVM, click **Add Game** and pick that folder. Or, from the command line:
   ```
   scummvm --path=<extracted-folder> cartlife
   ```

## Build and iterate

Setup is Windows + WSL. Install once:

```
winget install AGSProjectTeam.AdventureGameStudio   # AGS 3.6.2
winget install 7zip.7zip
sudo apt install rsync                              # in WSL
```

The loop:

1. Create a branch and edit the scripts (`cartlife/*.asc`, `*.ash`).
2. Build:
   ```
   tools/build.sh          # compile only
   tools/build.sh --run    # compile, then launch the game
   ```
3. Read the compiler output. Errors stop the build. Warnings don't.
4. Commit with sign-off (`git commit -s`; see [README.original.md](README.original.md)) and open a PR.

What `tools/build.sh` does:

- **Sprites:** on the first run it extracts `acsprset.spr` from the split `.rar`.
- **Mirror:** it copies `cartlife/` to `C:\Users\<you>\cartlife_work`, because AGS can't build from a `\\wsl$` path.
- **Compile:** it runs AGS headless, and the build lands in `C:\Users\<you>\cartlife_work\cartlife\Compiled\Windows\`.

## Notes

- **Run your builds with `cartlife.exe`, not ScummVM.** ScummVM can't run games compiled by AGS 3.6.2 yet.
- **The mirror is upgraded to AGS 3.6 on every build; the repo stays in 3.4 format.** Don't edit files in the mirror, because the next build overwrites them.
- **To change rooms, GUIs or sprites,** open `Game.agf` in the AGS editor from a Windows-local checkout. Opening it over `\\wsl$` hangs the editor.
- **Scripts are Windows-1252, not UTF-8.** Keep that encoding when editing.
