#!/bin/bash
#
# This script gets some picture files for our personal web pages, which are kept in public_html
# The pictures are put into a subdirectory of public_html named pics
# It does some error checking
# It summarizes the public_html/pics directory when it is done
#
# It should not be run as root
[ "$(whoami)" = "root" ] && echo "Not to be run as root" && exit 1

# Task 1: Improve this script to also retrieve and install the files kept in the https://zonzorp.net/pics.tgz tarfile
# - Use the same kind of testing that is already in the script to only download the tarfile if you don't already have it
#   and to make sure the download and extraction commands work
# - Then delete the local copy of the tarfile if the extraction was successful

# Make sure we have a clean pics directory to start with
rm -rf ~/public_html/pics
mkdir -p ~/public_html/pics || (echo "Failed to make a new pics directory" && exit 1)

# Download a zipfile of pictures to our Pictures directory - assumes you are online
# Unpack the downloaded zipfile if the download succeeded - assumes we have an unzip command on this system
# Delete the local copy of the zipfile after a successful unpack of the zipfile
wget -q -O ~/public_html/pics/pics.zip http://zonzorp.net/pics.zip && unzip -d ~/public_html/pics -o -q ~/public_html/pics/pics.zip && rm ~/public_html/pics/pics.zip

# Task 1: Improve this script to also retrieve and install the files kept in the https://zonzorp.net/pics.tgz tarfile
# Test to make sure the download and extraction commands work
# Then delete the local copy of the tarfile if the extraction was successful
if [ ! -f ~/public_html/pics/pics.tgz ]; then
    wget -q -O ~/public_html/pics/pics.tgz https://zonzorp.net/pics.tgz
    if [ $? -eq 0 ]; then
        tar -C ~/public_html/pics -xf ~/public_html/pics/pics.tgz
        if [ $? -eq 0 ]; then
            rm ~/public_html/pics/pics.tgz
        else
            echo "Failed to extract the tarfile."
        fi
    else
        echo "Failed to download the tarfile."
    fi
fi

# Make a report on what we have in the Pictures directory
if [ -d ~/public_html/pics ]; then
    cat <<EOF
Found $(find ~/public_html/pics -type f | wc -l) files in the public_html/pics directory.
The public_html/pics directory uses $(du -sh ~/public_html/pics | awk '{print $1}') space on the disk.
EOF
fi
