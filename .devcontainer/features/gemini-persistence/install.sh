#!/usr/bin/env bash
set -e

content_base_dir=/usr/local/share/github-michaeldcanady/devcontainer-features
feature_content_dir=$content_base_dir/gemini-persistence
on_create_script=$feature_content_dir/onCreate.sh

echo "Configuring Gemini CLI persistence..."

mkdir -p "$feature_content_dir"
cp onCreate.sh "$on_create_script"
chmod +x "$on_create_script"
