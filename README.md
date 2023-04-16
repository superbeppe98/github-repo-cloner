# GitHub Repository Cloner
The GitHub Repository Cloner is a bash script that allows you to clone or update multiple GitHub repositories from a user or a list of URLs. The script uses the GitHub API and your personal access token to obtain the list of repositories and clone/update them.

## Installation
To use this script, you will need:

* A GitHub account with API access
* A personal access token (PAT) with repo scope. You can create a PAT by following [these instructions](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token).

## Usage
Cloning repositories for a user
To clone all the repositories for a GitHub user, simply run the script with the username as the only argument:
```shell
$ ./github-repo-cloner.sh -u <GitHub username> -t <GitHub API token>
```

The script will clone or update all repositories owned by the specified GitHub user, as well as any repositories specified in a "repos.txt" file in the current directory.

## Notes
* The script will create a new directory called "repos" in the current directory to store the cloned repositories.
* If a repository has already been cloned, the script will perform a "git pull" to update it instead of cloning it again.
* The script uses the GitHub API to get the list of repositories owned by the user, so it may be subject to rate limiting if the user has a large number of repositories. To avoid this, you can provide a list of repositories in the "repos.txt" file.