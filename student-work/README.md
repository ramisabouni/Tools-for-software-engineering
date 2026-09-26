#GitHub Codespaces and Your Private Course Repository

## Purpose

You will work in your own private GitHub repository. It stores your exercises, assignments, and projects. Instructor-provided examples and starter files are updated separately so that course updates do not overwrite your work.

## 1. Create your private repository

1. Sign in to GitHub using your own account.
2. Open the instructor's **Tools for Software Engineering** template repository.
3. Select **Use this template**, followed by **Create a new repository**.
4. Choose your personal GitHub account as the owner.
5. Enter the repository name `EGEN5209-course-work`.
6. Select **Private** visibility.
7. Select **Create repository**.

Do not create the Codespace from the instructor's public repository. Create it from your new private repository.

## 2. Create the Codespace

From your private `EGEN5209-course-work` repository:

1. Select **Code**.
2. Select the **Codespaces** tab.
3. Select **Create codespace**.
4. Wait for the container setup to finish. The first setup can take several minutes.

The setup installs the course tools and creates the Python environment automatically.

## 3. Verify the environment

In the Codespaces terminal, run:

```bash
./setup/verify-course.sh
```

Do not use `sudo` for verification. The final output should report:

```text
ENVIRONMENT VERIFICATION PASSED
```

If Python packages appear missing, open a new terminal and run verification again. You can also load the course environment into the current terminal with:

```bash
source ~/.course-env
```

## 4. Confirm the repository connection

Run:

```bash
git remote -v
```

The `origin` address must contain your GitHub username and your private repository name:

```text
https://github.com/YOUR-USERNAME/EGEN5209-course-work.git
```

If `origin` points to the instructor's public repository, stop and create the Codespace from your private repository instead.

## 5. Keep all personal work in `student-work`

Use only these directories for files you create or modify:

```text
student-work/
├── assignments/
├── exercises/
└── projects/
```

The following directories are controlled by the instructor:

```text
.devcontainer/
datasets/
examples/
exercises/
scripts/
setup/
```

Do not complete work directly inside an instructor-managed directory. Copy the required starter material first. For example:

```bash
cp -r exercises/chapter03 student-work/exercises/
cd student-work/exercises/chapter03
```

## 6. Save and push your work

Check what has changed:

```bash
git status
```

Stage only the work you intend to save:

```bash
git add student-work/exercises/chapter03
```

Commit it with a meaningful message:

```bash
git commit -m "Complete Chapter 3 exercises"
```

Push the commit:

```bash
git push
```

Because the Codespace was created from your private repository, GitHub normally authenticates this push automatically. You should not need a personal access token.

Commit and push at the end of every working session. A Codespace is a development environment, not a substitute for version-controlled backup.

## 7. Receive course updates safely

Before updating, save your current work:

```bash
git status
git add student-work
git commit -m "Save work before course update"
git push
```

If Git reports that there is nothing to commit, continue.

Run the updater:

```bash
./setup/update-course.sh
```

The first run automatically adds an `upstream` connection to the instructor repository. The updater replaces only instructor-managed files. It does not modify `student-work/`.

Review the result:

```bash
git status
git diff --stat
```

Save the course update in your private repository:

```bash
git add .devcontainer datasets examples exercises scripts setup LICENSE README.md
git commit -m "Update course materials"
git push
```

If there were no new course files, Git may report that there is nothing to commit.

## 8. Rebuild after an environment update

If the update changes `.devcontainer`, `setup/setup.sh`, or the required software list:

1. Commit and push your work first.
2. Press `Ctrl+Shift+P` in Codespaces.
3. Select **Codespaces: Rebuild Container**.
4. Wait for setup to complete.
5. Open a new terminal.
6. Run:

```bash
./setup/verify-course.sh
```

## 9. Recovering from common problems

### Push returns error 403

Check the remote:

```bash
git remote -v
```

The Codespace must have been created from your private repository. Creating it from the public instructor repository gives it a different, restricted credential.

### The updater reports changes in instructor-managed files

Move your work into `student-work/`, then restore the instructor-managed files:

```bash
git status
```

Ask the instructor before discarding anything you are unsure about.

### Python packages are reported missing

Run verification without `sudo`:

```bash
source ~/.course-env
./setup/verify-course.sh
```

### Your Codespace was deleted

Create a new Codespace from your private repository. Anything committed and pushed to GitHub will be restored. Uncommitted work may not be recoverable.

## Weekly routine

At the beginning of a working session:

```bash
git pull
./setup/update-course.sh
```

After reviewing the update, commit it if necessary. At the end of the session:

```bash
git status
git add student-work
git commit -m "Describe the work completed"
git push
```
