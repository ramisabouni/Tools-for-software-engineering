# Tools-for-software-engineering
Repository used for "Tools for Software Engineering" text book

## Book Environment

This repository contains the software environment, examples, exercises,
datasets, and starter projects used in the course.

Students can use one of three options to access the course material:
- Use codespaces and follow the instructions below.
- use an Ubuntu Linux workspace provided through Prepare.sh.
- Create their own Ubuntu Linux on a virtual machine


## Getting Started

The course environment is automatically configured when you follow these instructions.

## Using Codespaces.

Create your personal repository from this course template. To do so, follow these steps:
1. Select **Use this template**.
2. Create a private repository named `EGEN5209-course-work`.
3. Create the Codespace from that private repository.
   - Optional: Open the codespace in VS-Code.
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
## Using preparesh
If you would like to use prepare.sh to create your own online environment, follow these steps:

1- Create an account on prepare.sh
2- Create an environment on Prepare.sh
3- Clone the course repository to the environment
4- ```bash Run ./setup/setup.sh ```
5- ```bash Run ./setup/verify-course.sh ```

## Using your own Ubuntu Linux on a virtual machine
If you would like to use your own Linux image, follow these steps:

Create a version of Linux on your virtual machine

1- Clone the course repository to the environment
2- ```bash Run ./setup/setup.sh ```
3- ```bash Run ./setup/verify-course.sh ```
