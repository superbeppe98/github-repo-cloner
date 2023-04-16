#!/bin/bash

# Parse the command-line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -u|--username)
        github_username="$2"
        shift
        shift
        ;;
        -t|--token)
        github_token="$2"
        shift
        shift
        ;;
        *)
        echo "Unknown argument: $1"
        exit 1
        ;;
    esac
done

# Check that the username and token have been provided
if [ -z "$github_username" ] || [ -z "$github_token" ]; then
    echo "Usage: $0 -u <GitHub username> -t <GitHub API token>"
    exit 1
fi

# Set the file path for the list of repository URLs
url_list_file="repos.txt"

# Set the destination folder path
dest_folder="$(pwd)/repos"

# Create the destination folder if it doesn't exist
mkdir -p "$dest_folder"

# Get the list of repositories for the user
repositories=$(curl -s -H "Authorization: token $github_token" "https://api.github.com/user/repos?per_page=1000")

# Clone or update each repository listed in the response
for repo_url in $(echo "$repositories" | grep -Eo '"clone_url": "([^"]+)"' | awk '{print $2}' | tr -d '"'); do
    # Extract the name of the repository from the URL
    repo_name="$(basename "$repo_url" .git)"
    echo "$repo_name"

    # Check if the repository has already been cloned
    if [ -d "$dest_folder/$repo_name" ]; then
        # Update the repository
        cd "$dest_folder/$repo_name"
        git pull
        cd -
    else
        # Clone the repository
        git clone "$repo_url" "$dest_folder/$repo_name"
    fi
done

# Read each URL from the URL list file and clone or update the corresponding repository
for url in $(cat "$url_list_file"); do
    # Extract the name of the repository from the URL
    repo_name="$(basename "$url" .git)"
    echo "$repo_name"

    # Check if the repository has already been cloned
    if [ -d "$dest_folder/$repo_name" ]; then
        # Update the repository
        cd "$dest_folder/$repo_name"
        git pull
        cd -
    else
        # Clone the repository
        git clone "$url" "$dest_folder/$repo_name"
    fi
done

