#!/bin/bash

# List mounted devices
echo "Mounted devices:"
echo "================"
df -h | awk 'NR>1 {print $1,$NF}'
