#!/bin/bash

python3 - "$@" << 'EOF'
import os
import sys
import shutil

def collect_files(input_dir, output_dir, max_depth):
    os.makedirs(output_dir, exist_ok=True)
    
    for root, _, files in os.walk(input_dir):
        for file in files:
            src_file = os.path.join(root, file)
            
            rel_path = os.path.relpath(src_file, input_dir)
            path_parts = rel_path.split('/')
            
            if len(path_parts) > max_depth:
                truncated_parts = path_parts[-max_depth:]
                dst_path = os.path.join(output_dir, *truncated_parts)
            else:
                dst_path = os.path.join(output_dir, rel_path)
            
            os.makedirs(os.path.dirname(dst_path), exist_ok=True)
            
            shutil.copy2(src_file, dst_path)

max_depth = 1
args = sys.argv[1:]

if len(args) >= 2:
    max_depth = int(args[-1])
    args = args[:-2]

input_dir, output_dir = args

if not os.path.isdir(input_dir):
    sys.exit(1)

collect_files(input_dir, output_dir, max_depth)
EOF
