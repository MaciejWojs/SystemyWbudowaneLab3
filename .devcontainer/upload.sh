#!/usr/bin/env bash
filename="main.pdf"
filename_without_extension="${filename%.*}"

if [ ! -f $filename ]; then
    echo "File $filename not found"
    exit 1
fi
output=$(curl -sS -X POST -F "file=@$filename" https://store1.gofile.io/contents/uploadfile)

if [ -f $filename_without_extension-compressed.pdf ]; then
    code=$(echo $output | jq -r '.data.parentFolder')
    guestToken=$(echo $output | jq -r '.data.guestToken')
    curl -sS -X POST -H "Authorization: Bearer $guestToken" -F "file=@dokument-compressed.pdf" -F "folderId=$code" https://store1.gofile.io/contents/uploadfile &> /dev/null
else
    echo "File dokument-compressed.pdf not found"
fi

echo Download URL:  $(echo $output | jq -r '.data.downloadPage')