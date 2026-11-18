#!/usr/bin/env sh
set -eu

if [ "$#" -ne 1 ]; then
    printf 'usage: %s NEW_TARGET_DIRECTORY\n' "$0" >&2
    exit 2
fi
root=$1
[ ! -e "$root" ] || { printf 'Refusing to overwrite: %s\n' "$root" >&2; exit 2; }
mkdir -p "$root"
remote="$root/course-remote.git"
git init -q --bare "$remote"
git clone -q "$remote" "$root/instructor"
git -C "$root/instructor" config user.name Instructor
git -C "$root/instructor" config user.email instructor@example.invalid
printf 'Course repository baseline\n' > "$root/instructor/README.md"
git -C "$root/instructor" add README.md
git -C "$root/instructor" commit -q -m 'Establish remote baseline'
git -C "$root/instructor" branch -M main
git -C "$root/instructor" push -q -u origin main
git --git-dir="$remote" symbolic-ref HEAD refs/heads/main
git clone -q "$remote" "$root/student"
git -C "$root/student" config user.name Student
git -C "$root/student" config user.email student@example.invalid

printf 'New instructor material\n' > "$root/instructor/topic.txt"
git -C "$root/instructor" add topic.txt
git -C "$root/instructor" commit -q -m 'Publish new course material'
git -C "$root/instructor" push -q

cat > "$root/NEXT-STEPS.md" <<EOF
# Local remote demonstration

The instructor clone has pushed one commit. The student clone has not fetched it,
so its \`origin/main\` is stale.

Run:

\`\`\`bash
git -C "$root/student" status --short --branch
git -C "$root/student" log --oneline --graph --decorate --all
git -C "$root/student" fetch origin
git -C "$root/student" log --oneline --graph --decorate --all
git -C "$root/student" log HEAD..origin/main --oneline
git -C "$root/student" diff --stat HEAD...origin/main
\`\`\`

Fetch updates remote-tracking knowledge. It does not change the checked-out branch
or working tree. This demonstration uses no external service or credential.
EOF

printf 'Prepared local remote demonstration at %s\nSee %s/NEXT-STEPS.md\n' "$root" "$root"
