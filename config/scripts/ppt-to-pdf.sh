#!/usr/bin/env bash

mkdir -p converted_pdfs

[[ -x soffice ]] || echo "soffice is missing." && return 1

for file in *.ppt *.pptx; do
    if [[ -f "$file" ]]; then
        echo "Converting "$file" to pdf ..."

        soffice --headless --convert-to pdf "$file" --outdir ./converted_pdfs

        if [[ "$?" ]]; then
            echo "Sucessfully converted "$file"."
        else
            echo "Failed to convert "$file"."
        fi
    fi
done
