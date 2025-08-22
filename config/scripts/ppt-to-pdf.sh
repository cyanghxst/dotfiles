#!/usr/bin/env bash

mkdir -p converted_pdfs

command -v soffice >/dev/null 2>&1 || { echo "soffice is missing."; exit 1; }

for file in *.ppt *.pptx; do
    if [[ -f "$file" ]]; then
        echo "Converting "$file" to pdf..."

        soffice --headless --convert-to pdf "$file" --outdir ./converted_pdfs >/dev/null

        if [[ "$?" ]]; then
            printf "Sucessfully converted %s.\n\n" "$file"
        else
            printf "Failed to convert %s.\n\n" "$file"
        fi
    fi
done
