#!/usr/bin/env python3

"""
Script to validate Markdown links and image references in documentation.
Checks if links to other markdown files exist and if image paths are valid.
"""

import os
import re
import sys
from pathlib import Path
from typing import List, Tuple

# ANSI color codes for terminal output
RED = "\033[91m"
YELLOW = "\033[93m"
GREEN = "\033[92m"
RESET = "\033[0m"

# Regex patterns for finding markdown links and image references
LINK_PATTERN = r'\[([^\]]+)\]\(([^)]+)\)'
IMAGE_PATTERN = r'!\[([^\]]*)\]\(([^)]+)\)'


def check_file_exists(file_path: str) -> bool:
    """Check if a file exists at the given path."""
    return os.path.isfile(file_path)


def resolve_path(base_dir: str, link_path: str) -> str:
    """Resolve a link path relative to the base directory."""
    # Handle absolute paths (starting with /)
    if link_path.startswith('/'):
        # Strip leading '/' and make it relative to the project root
        return os.path.normpath(os.path.join(os.getcwd(), link_path[1:]))

    # Handle relative paths
    return os.path.normpath(os.path.join(base_dir, link_path))


def validate_markdown_links(file_path: str) -> List[Tuple[int, str, str]]:
    """
    Validate markdown links in a file.
    Returns a list of tuples containing (line_number, link_text, target_path) for broken links.
    """
    errors = []
    base_dir = os.path.dirname(file_path)
    
    with open(file_path, 'r', encoding='utf-8') as f:
        for line_num, line in enumerate(f, 1):
            # Find all markdown links in the line
            for match in re.finditer(LINK_PATTERN, line):
                link_text, link_path = match.groups()
                
                # Skip external links and anchors
                if link_path.startswith(('http://', 'https://', 'ftp://', 'mailto:', 'tel:', '#')):
                    continue
                
                # Only check .md files and other known document types
                if link_path.endswith(('.md', '.markdown', '.txt', '.rst')):
                    target_path = resolve_path(base_dir, link_path)
                    
                    if not check_file_exists(target_path):
                        errors.append((line_num, link_text, link_path))
    
    return errors


def validate_image_references(file_path: str) -> List[Tuple[int, str]]:
    """
    Validate image references in a file.
    Returns a list of tuples containing (line_number, image_path) for broken images.
    """
    errors = []
    base_dir = os.path.dirname(file_path)
    
    with open(file_path, 'r', encoding='utf-8') as f:
        for line_num, line in enumerate(f, 1):
            # Find all image references in the line
            for match in re.finditer(IMAGE_PATTERN, line):
                alt_text, image_path = match.groups()
                
                # Skip external images
                if image_path.startswith(('http://', 'https://', 'ftp://', 'data:')):
                    continue
                
                target_path = resolve_path(base_dir, image_path)
                
                if not check_file_exists(target_path):
                    errors.append((line_num, image_path))
    
    return errors


def validate_docs_directory(docs_dir: str = './docs') -> int:
    """
    Validate all markdown files in the docs directory.
    Returns the total number of errors found.
    """
    print(f"Validating Markdown links and image references in {docs_dir}...")
    
    total_errors = 0
    
    # Find all markdown files
    markdown_files = []
    for root, _, files in os.walk(docs_dir):
        for file in files:
            if file.endswith(('.md', '.markdown')):
                markdown_files.append(os.path.join(root, file))
    
    for file_path in sorted(markdown_files):
        print(f"Processing {file_path}...")
        
        # Validate markdown links
        link_errors = validate_markdown_links(file_path)
        if link_errors:
            for line_num, link_text, link_path in link_errors:
                target_path = resolve_path(os.path.dirname(file_path), link_path)
                print(f"{RED}ERROR:{RESET} Broken link in {file_path} (line {line_num}): "
                      f"[{link_text}]({link_path}) -> {target_path} does not exist")
                total_errors += 1
        
        # Validate image references
        image_errors = validate_image_references(file_path)
        if image_errors:
            for line_num, image_path in image_errors:
                target_path = resolve_path(os.path.dirname(file_path), image_path)
                print(f"{RED}ERROR:{RESET} Broken image reference in {file_path} (line {line_num}): "
                      f"{image_path} -> {target_path} does not exist")
                total_errors += 1
    
    # Print summary
    print("\n=== Validation Complete ===")
    
    if total_errors == 0:
        print(f"{GREEN}All links and image references are valid!{RESET}")
        return 0
    
    print(f"Found {RED}{total_errors} errors{RESET}")
    return 1 if total_errors > 0 else 0


if __name__ == "__main__":
    # Check if docs directory exists
    docs_dir = './docs'
    images_dir = './images'
    
    if not os.path.isdir(docs_dir):
        print(f"{RED}ERROR:{RESET} Documentation directory {docs_dir} does not exist")
        sys.exit(1)
    
    if not os.path.isdir(images_dir):
        print(f"{RED}ERROR:{RESET} Images directory {images_dir} does not exist")
        sys.exit(1)
    
    # Run validation
    exit_code = validate_docs_directory(docs_dir)
    sys.exit(exit_code)