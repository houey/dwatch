#!/bin/bash
RESET='\033[0m'
HTTPFOUND='\033[0;31mPOSSIBLY_AVAILABLE:\033[0;32m'
HTTPSFOUND='\033[0;31mURGENT_VALIDATION_REQUIRED:\033[0;32m'

if [[ $# -eq 0 ]] ; then
    echo -e "\n\t\033[0;32mDomainWatch\033[0m - Monitor domain lists for possible take-over\n\n\tScan your domain list:\n\t\t./${0##*/} scan <domain_list>\n\n\tAdd a 
domain to your domain list:\n\t\t./${0##*/} add <domain> <domain_list>\n"
    exit 0
fi

if [[ $1 == "add" ]]; then
    echo "$2" >> "$3"
    echo -e "\n\tDomain \033[0;32m$2\033[0m added to \033[0;32m$3\033[0m!\n"
    exit 0
elif [[ $1 == "scan" ]]; then
    while IFS='' read -r line || [[ -n "$line" ]]; do
        HTMLS=$(curl -Lks "https://$line" --max-time 5)
        HTML=$(curl -Lks "$line" --max-time 5)
        if [[ $HTMLS == *"NoSuchBucket"* ]]; then
		echo -e "${HTTPSFOUND} Https S3 Bucket!${RESET} $line"
        elif [[ $HTML == *"NoSuchBucket"* ]]; then
            echo -e "${HTTPFOUND} S3 Bucket!${RESET} $line"
        fi
    done < "$2"
fi
