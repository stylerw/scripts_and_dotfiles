#!/bin/python
# Helper script to allow application choosing, snippet pasting, and fuzzy launching
# Will Styler and ChatGPT
import os
import shlex
import subprocess
import re

# Initialize fzf core
from pyfzf.pyfzf import FzfPrompt
fzf = FzfPrompt()

# Read deadkeyed commands from launcher.txt and return them as a dictionary
def load_commands():
    command_dict = {}
    with open("/home/wstyler/Documents/bin/python_launcher.txt", "r") as file:
        for line in file:
            # Select only the items which are designated as deadkeys
            if "!! " in line:
                # Create Dictionary of Deadkeys
                key, command = line.strip().split("!! ")
                command_dict[key] = command
    return command_dict

# This bit allows me to do fuzzy matching from the command file
def fzsnip():
    fzover = "wait"
    # Read the command file again, and split by ---
    with open('/home/wstyler/Documents/bin/python_launcher.txt', 'r') as f:
        data = f.read()
    snips = re.split("\n---\n", data)
    processed_snippets = []
    # Create a list of processed snippets
    for snip in snips:
        # Remove hotkey snippets
        if "!! " not in snip:
            snipfix = re.sub(r'(#!.*?)\n', r'\1', snip)
            processed_snippets.append(repr(snipfix.strip()).strip('\'').strip('\"'))
    # Get the FzF output
    fzoutput = str(fzf.prompt(processed_snippets)[0])
    # Remove the non-command output
    fzoutputfixed1 = re.sub(r'#!.*?\\n', '', fzoutput)
    # If it's deadkey (like ac!!) treat as !r
    fzoutputfixed = re.sub(r"^[^!!]*!! ", "!r", fzoutputfixed1, flags=re.MULTILINE)
    # If it's runnable, run it
    if fzoutputfixed.startswith('!r'):
        command = fzoutputfixed[2:].strip()
        print(command)
        subprocess.run(command, shell=True)
    else:
        # If it's not runnable, copy it to the clipboard (this line changes for Wayland)
        safe_output = shlex.quote(fzoutputfixed)
        # This fixes the fact that wl-copy doesn't automatically fix //n
        safe_output = safe_output.replace("\\n", "\n")
        # FOR X11 
        # subprocess.run(f'echo {safe_output} | xsel -ib', shell=True)
        # For Wayland
        subprocess.run(f'echo {safe_output} | wl-copy', shell=True)
    return fzover

# Allow input without enter, creating a character sink
def getch():
    import sys, termios
    fd = sys.stdin.fileno()
    orig = termios.tcgetattr(fd)
    new = termios.tcgetattr(fd)
    new[3] = new[3] & ~termios.ICANON
    new[6][termios.VMIN] = 1
    new[6][termios.VTIME] = 0

    try:
        termios.tcsetattr(fd, termios.TCSAFLUSH, new)
        return sys.stdin.read(1)
    finally:
        termios.tcsetattr(fd, termios.TCSAFLUSH, orig)

# Main function
def main():
    # Pull in Deadkey commands
    runhere = 0
    commands = load_commands()
    print('Yes, meatbag? ', end='', flush=True)
    command = getch()
    # If we go to 's', then head straight to fzf country
    if command == 's':
        bashrun = fzsnip()
        # This just returns 'wait' if fzf fired to avoid failing
    # If it's something besides 's', check against command list
    else:
        runhere = 1
        if command in commands:
            bashrun = commands[command]
        else:
            # Check if part of a multi-key command
            command += getch()
            if command in commands:
                bashrun = commands[command]
            else:
                # Check if part of a multi-key command (This allows us to go up to three keys deep)
                command += getch()
                if command in commands:
                    bashrun = commands[command]
                else:
                    print("Invalid input, meatbag.")
                    return
    print(bashrun)
    print(runhere)
    # Run the command
    if runhere == 1:
        subprocess.run(bashrun, shell=True)

if __name__ == "__main__":
    main()
    #fzsnip()
