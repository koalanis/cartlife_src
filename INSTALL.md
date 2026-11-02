# Install / Run

The playable build is in `cartlife/Compiled/Compiled.rar`. One way to run it is with [ScummVM](https://www.scummvm.org/) (2.5 or later):

1. Install ScummVM, e.g. `winget install ScummVM.ScummVM` on Windows.
2. Extract `cartlife/Compiled/Compiled.rar` to a folder outside the repo, e.g. with 7-Zip.
3. In ScummVM, click **Add Game** and pick that folder. Or, from the command line:
   ```
   scummvm --path=<extracted-folder> cartlife
   ```

To edit and build the game you need [Adventure Game Studio](https://www.adventuregamestudio.co.uk/). See [README.original.md](README.original.md).
