#!/bin/bash
# This script compares different translation engines.
# Currently, it compares microsoft/google/yandex/mymemory-translate
# when translating from unknown source language into English, using
# the console scripts I've also cooked up.
# Just pass whatever you want translated as argument(s) to the script.
echo -n 'Microsoft Translate: '
microsoft-translate.sh '' en "$@"
echo
echo -n '   Google Translate: '
google-translate.sh auto en "$@"
echo
echo -n '   Yandex Translate: '
yandex-translate.sh '' en "$@"
echo
echo -n ' MyMemory Translate: '
mymemory-translate.sh '' en "$@"
echo
