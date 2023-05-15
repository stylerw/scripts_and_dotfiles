#!/bin/bash

# Text Generating script for Pandoc and a Markdown/Obsidian based workflow
# Will Styler - 2021-2023
# This is designed to run periodically and generate reveal.js slides, handouts, letters, and more, modifying only those items which have changed. 

# This makes sure that it finds XeLaTeX
export PATH="$PATH:/Library/TeX/texbin/"

# First do talks (in reveal.js) by entering the folder where all my markdown files for my talks live
cd ~/Documents/text/talks
# Find all markdown in the folder
find . -name "*.md" | while read ffname; do
    # Derive a base filename for the new versions
	filename=$(basename -- "$ffname")
	fn="${filename%.*}"
    # Check to see if the existing html file in the generated talks folder is older than the current markdown, and if so...
    if [[ $ffname -nt ~/Documents/talks/$fn.html ]]; then
    	# Pull out the title bit
        head -1 $ffname | sed 's/$ //' > /tmp/rev.txt
        # Pull out the post-title bit (e.g. the body)
        tail -n+2 $ffname > /tmp/rev2.txt
        # Concatenate the chunks of html around the title and body in the right folder
        cat ~/Documents/bin/templates/reveal_pretitle.html /tmp/rev.txt  ~/Documents/bin/templates/reveal_head.html /tmp/rev2.txt ~/Documents/bin/templates/reveal_foot.html > ~/Documents/talks/$fn.html
        # Create handout versions of slides
        # Remove the title
        tail -n+2 $ffname > /tmp/$fn_handout.md
        ffname="/tmp/$fn_handout.md"
        # Homebrew it
        /opt/homebrew/bin/pandoc -s "$ffname" -H ~/Documents/bin/pandoc_handout.css --from markdown-yaml_metadata_block -o ~/Documents/talks/"$fn"_handout.html

    fi
done

# Now generate documents
cd ~/Documents/docs
# Again find modifications relative to the markdown files, in this case where the html is older than the markdown
find ~/Documents/text/docs -name "*.md" | while read ffname; do
	filename=$(basename -- "$ffname")
    filedir=$(dirname -- "$myfile")
	fn="${filename%.*}"
    if [[ $ffname -nt ~/Documents/docs/$fn.html ]]; then
        echo $fn
        # Check if the %pdf flag is present, if so
        if grep -q '%pdf' "$ffname"; then
            # Remove the flag from the file, and adjust the path for future compilation
            sed '/%pdf/d' $ffname > /tmp/edfile.md
            ffname="/tmp/edfile.md"
            # Render the pdf
            /opt/homebrew/bin/pandoc -s "$ffname" --pdf-engine=xelatex --from markdown --template $HOME/Documents/bin/pandoc/templates/genericdoc.tex -o "$fn".pdf
        fi
        # Render the HTML
        /opt/homebrew/bin/pandoc -s "$ffname" -H ~/Documents/bin/pandoc.css -o "$fn".html
    fi
done

# This is the same process and code as the documents folder, except these go in a different folder.
cd ~/Documents/offline
find ~/Documents/text/offline -name "*.md" | while read ffname; do
	filename=$(basename -- "$ffname")
    filedir=$(dirname -- "$myfile")
	fn="${filename%.*}"
    if [[ $ffname -nt ~/Documents/offline/$fn.html ]]; then
        echo $fn
        # Check if the %pdf flag is present, if so
        if grep -q '%pdf' "$ffname"; then
            # Remove the flag from the file, and adjust the path for future compilation
            sed '/%pdf/d' $ffname > /tmp/edfile.md
            ffname="/tmp/edfile.md"
            # Render the pdf
            /opt/homebrew/bin/pandoc -s "$ffname" --pdf-engine=xelatex --from markdown --template $HOME/Documents/bin/pandoc/templates/genericdoc.tex -o "$fn".pdf
        fi
        # Render the HTML
        /opt/homebrew/bin/pandoc -s "$ffname" -H ~/Documents/bin/pandoc.css -o "$fn".html
    fi
done

# Now, find cases where PDF letters of rec are older than the markdown version
cd ~/Documents/letters
find ~/Documents/text/letters -name "*.md" | while read ffname; do
	filename=$(basename -- "$ffname")
    filedir=$(dirname -- "$myfile")
	fn="${filename%.*}"
    if [[ $ffname -nt ~/Documents/letters/$fn.pdf ]]; then
        echo $fn
        # If the PDF is older, generate a new one with Pandoc and Xelatex, using the letter of recommendation template
        /opt/homebrew/bin/pandoc -s "$ffname" --pdf-engine=xelatex --from markdown --template $HOME/Documents/bin/pandoc/templates/letterrec.tex -o "$fn".pdf
    fi
done


