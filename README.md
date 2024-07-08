## Will's Script and Dotfile Repository

A set of shell scripts, dotfiles, python scripts, and configurations which I use and want to share.

### python_scripts

- **tipafy.py**: This script [converts Unicode IPA into TIPA](https://wstyler.ucsd.edu/posts/unicode_to_tipa.html). You should use XeLaTeX and native unicode rather than doing this, but it's a useful hack.

- **will_python_launcher.py**: This, combined with will_python_launcher.txt which defines its behavior, is a launcher script that I use to quickly start applications (flatpak, bin, and cli), open folders/websites, copy snippets to my clipboard, or, in a secondary mode, to use [fzf](https://github.com/junegunn/fzf) to search commands and code snippets, and either run them, or copy them to the keyboard.
    - On invocation, it takes single letters or combinations of letters, 'deadkey' style. These are labeled with XX!! in the txt file, where XX is the combination of letters. So, the command after  `dts!!` would trigger after you hit D, then T, then S. But if you have something with `d!!`, that'd trigger the moment you hit 'd'. It's very much a 'deadkey' approach. So, single-letter keys are given a chance to fire, and if none are found, then two letter combos, then...
        - You'll see use of [gobble](https://github.com/EmperorPenguin18/gobble) which, combined with `nohup` and `&`, allows programs to be launched without leaving the window behind. This is really, really hacky, and I wish there were a way to trigger a windowless run of flatpaks and such, but this works. I use a tiling window manager, so having extra windows which 'contain' a running GUI app is undesirable.
    - If you hit 's', you'll be put into a mode where it searches the non-deadkey contents of the text file with fzf. Anything prefaced with !r will be run in the shell, anything without that will be copied to the clipboard. Half of these things are 'things I know how to do but couldn't give the command for if you held a gun to my head', here for quick reference. The file has been pared down some for public posting, just because many of the snippets aren't needed outside my life.
    - It's designed to be run with a keyboard shortcut, so that I have an instant launcher pop-up in my terminal of choice ([Kitty](https://sw.kovidgoyal.net/kitty/)). So, I have a KDE shortcut bound to...
        - `kitty --title launcher zsh -c "python $HOME/Documents/bin/launcher.py"`


### shell_scripts

- **gen_slides_docs_letters.sh**: This is a script which automatically generates my slides, documents, letters of recommendation, and more.

### cad_3dmodels

- **spectrogram_creation**: This code and image are a companion to [How to make a spectrogram into a 3D Printed Physical Object](https://savethevowels.org/posts/spectrogram_to_stl.html).
