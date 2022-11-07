# Git code version control

## Exercises

### SSH key

1. Create or make sure you have prepared an SSH key.

1. Edit your `~/.ssh/config` file and add the following:

    ```
    Host github.com
      User git
      IdentityFile ~/.ssh/my-private-key-filename
      IdentitiesOnly = true
    ```

    NOTE: If you don't have the SSH key yet, you can create one with:

    * `ssh-keygen` on Linux/Mac 
    * `PuTTYgen` on Windows

### Local version setup

1. Verify that the `git` is installed in your system:

    ```bash
    $ git version

    git version 2.25.1
    ```

1. If necessary, install the git for your operating system using any tutorial - you can use [https://www.atlassian.com/git/tutorials/install-git](https://www.atlassian.com/git/tutorials/install-git) for example.
1. In the top right corner of Github page, expand your profile menu and select `Settings`.
1. On the profile page, select `SSH and GPG keys`.
1. On the `SSH keys` select "New SSH key" option and paste your public SSH key.
1. Once the SSH key has been uploaded, proceed back to the repository dashboard.
1. Select the green `Code` button and make sure the Clone "SSH" is selected. Copy the link. 
1. In the terminal, go to the location you want the code to be replicated into and issue the `git clone` command:

    ```bash
    git clone <COPIED_URL_REPO_LINK>
    # should be in the format: git@github.com:username/repository
    ```

1. Switch to the cloned directory and configure git:

    ```bash
    git config --add user.email "your_email@mail.com" 
    git config --add user.name "FirstName LastName"
    ```

### Create and push your own branch

1. Go into the cloned directory.
1. Create your branch:

    ```bash
    git checkout -b pick-your-name-of-the-branch
    ```

1. Add a file:

    ```bash
    echo "My keys" > keys.txt
    git add .
    ```

1. Commit the file with comment:

    ```bash
    git commit -a -m 'Added the file'
    ```

1. Push to the GitHub:

    ```bash
    git push
    ```

    NOTE: When pushing for the first time, you will need to set up the name of the branch at origin (best leave it the same), ONCE:

    ```bash
    git push --set-upstream origin pick-your-name-of-the-branch
    ```

### Merge from the main branch (update)

1. Change to main branch and update:

    ```bash
    git checkout main
    git pull
    ```

1. Change back to your branch and merge new changes:

    ```bash
    git checkout pick-your-name-of-the-branch
    git merge main
    git commit -a -m 'Merge main'
    git push
    ```
