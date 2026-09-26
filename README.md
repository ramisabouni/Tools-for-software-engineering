# Tools-for-software-engineering
Repository used for "Tools for Software Engineering" text book

## Book Environment

This repository contains the software environment, examples, exercises,
datasets, and starter projects used in the course.

Students have one of three options to use the course material:
- Create their own Ubuntu Linux virtual machine
- Use codespaces and follow the instructions below.
- use an Ubuntu Linux workspace provided through Prepare.sh.

## Getting Started

The course environment is automatically configured when your Prepare.sh
workspace is created.

To verify your environment, run:

```bash
~/course/setup/verify-course.sh
```

## Open the course workspace (If you are using codespaces)

Create your personal repository from this course template. To do so, follow these steps:
1. Select **Use this template**.
2. Create a private repository named `EGEN5209-course-work`.
3. Create the Codespace from that private repository.
4. Wait for automatic setup to finish.
5. Run `./setup/verify-course.sh` without `sudo`.
6. Put personal work only under `student-work/`.
7. Commit and push student work regularly.
8. Run `./setup/update-course.sh` to receive instructor updates.
9. Review, commit, and push the resulting course-material update.

After the environment opens, run:

```bash
./setup/verify-course.sh
```

```markdown
[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/ramisabouni/Tools-for-software-engineering?quickstart=1)
```
