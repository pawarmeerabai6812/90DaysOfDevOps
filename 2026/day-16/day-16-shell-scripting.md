
# Day 16 – Shell Scripting Basics

## Task 1: The Shebang & Your First Script

### 1. What is shell scripting?
- A shell script is a plain text file of commands that Bash executes line by line.
- Automates repetitive DevOps work: deployments, health checks, user management, backups.

### 2. The shebang line: `#!/bin/bash`
- `#!` tells the OS the file is a script.
- `/bin/bash` is the interpreter that should run it.
- Without it, `./hello.sh` may run with the default shell (`sh`/`dash`) and Bash-only features can break.

| Scenario | What happens |
|----------|--------------|
| With `#!/bin/bash` | Runs with Bash – all features work |
| No shebang, run via `bash hello.sh` | Still works – Bash is called explicitly |
| No shebang, run via `./hello.sh` | Risky – OS uses the default shell |

### 3. `hello.sh`

```bash
#!/bin/bash
echo "Hello, DevOps!"
```

```bash
touch hello.sh      # create the file
nano hello.sh       # add the script
chmod +x hello.sh   # make it executable
./hello.sh          # run it
```

Output: `Hello, DevOps!`

### 4. What does `chmod +x` do?
- Adds the **execute** permission (Linux permissions: read `r`, write `w`, execute `x`).
- Without it: `bash: ./hello.sh: Permission denied`.

---

## Task 2: Variables

### 1. `variables.sh`

```bash
#!/bin/bash

NAME="Mira"
ROLE="DevOps Engineer"

echo "Hello, I am $NAME and I am a $ROLE"
```

Output: `Hello, I am Mira and I am a DevOps Engineer`

### 2. Rules
- No spaces around `=` → `NAME="Mira"` (not `NAME = "Mira"`).
- Use `$NAME` to read a variable; `"${NAME}"` is the safest form.

### 3. Single vs double quotes

| Quote type | Expands `$VAR`? | Example output |
|------------|-----------------|----------------|
| Double `"..."` | Yes | `echo "Hello, $NAME"` → `Hello, Mira` |
| Single `'...'` | No (literal) | `echo 'Hello, $NAME'` → `Hello, $NAME` |

---

## Task 3: User Input with `read`

### 1. `greet.sh`

```bash
#!/bin/bash

read -p "Enter your name: " USER_NAME
read -p "Enter your favourite tool: " FAV_TOOL

echo "Hello $USER_NAME, your favourite tool is $FAV_TOOL"
```

Sample run:

```
Enter your name: Mira
Enter your favourite tool: Github Action
Hello Nandan, your favourite tool is Github Action
```

### 2. How `read` works
- Pauses the script and waits for the user to type + press Enter.
- `-p "text"` shows a prompt.
- The typed value is stored in the variable you name.

---

## Task 4: If-Else Conditions

### 1. Syntax

```bash
if [ condition ]; then
    # runs if TRUE
elif [ another_condition ]; then
    # runs if the first was FALSE and this is TRUE
else
    # runs if ALL conditions were FALSE
fi
```

- `fi` closes the block (`if` backwards).

### 2. `check_number.sh` – positive, negative or zero

```bash
#!/bin/bash

read -p "Enter a number: " NUM

if [ $NUM -gt 0 ]; then
    echo "$NUM is Positive"
elif [ $NUM -lt 0 ]; then
    echo "$NUM is Negative"
else
    echo "The number is Zero"
fi
```

| Input | Output |
|-------|--------|
| 43 | 43 is Positive |
| -4 | -4 is Negative |
| 0 | The number is Zero |

### 3. Numeric comparison operators

| Operator | Meaning | Example |
|----------|---------|---------|
| `-gt` | greater than | `[ $N -gt 0 ]` |
| `-lt` | less than | `[ $N -lt 0 ]` |
| `-eq` | equal to | `[ $N -eq 0 ]` |
| `-ge` | greater than or equal | `[ $N -ge 10 ]` |
| `-le` | less than or equal | `[ $N -le 10 ]` |
| `-ne` | not equal | `[ $N -ne 5 ]` |

- For strings, use `=` and `!=` instead.

### 4. `file_check.sh` – does the file exist?

```bash
#!/bin/bash

read -p "Enter a filename to check: " FILENAME

if [ -f "$FILENAME" ]; then
    echo " File '$FILENAME' exists."
else
    echo " File '$FILENAME' does NOT exist."
fi
```

### 5. File test operators

| Flag | Checks if... |
|------|--------------|
| `-f` | it's a regular file |
| `-d` | it's a directory |
| `-e` | it exists (file or directory) |
| `-r` | it's readable |
| `-w` | it's writable |
| `-x` | it's executable |

- Always quote the variable (`"$FILENAME"`) so names with spaces work.

---

## Task 5: Putting It Together – `server_check.sh`

### 1. The script

```bash
#!/bin/bash

SERVICE="nginx"

echo "Service selected: $SERVICE"
read -p "Do you want to check the status? (y/n): " CHOICE

if [ "$CHOICE" = "y" ]; then
    STATUS=$(systemctl is-active $SERVICE)
    if [ "$STATUS" = "active" ]; then
        echo "$SERVICE is ACTIVE and running."
    else
        echo "$SERVICE is NOT active. Current status: $STATUS"
    fi
elif [ "$CHOICE" = "n" ]; then
    echo "Skipped."
else
    echo "Invalid input. Please enter 'y' or 'n'."
fi
```

### 2. Concepts used
- **Command substitution**: `$(...)` runs a command and captures its output, e.g. `STATUS=$(systemctl is-active nginx)`.
- **String comparison**: use `=` and quote the variable → `[ "$STATUS" = "active" ]`.
- **Nested if**: check the user's choice first, then check the service status.

---

## File Summary

| File | Purpose |
|------|---------|
| `hello.sh` | First script - shebang + echo |
| `variables.sh` | Variable declaration, single vs double quotes |
| `greet.sh` | Interactive user input with `read` |
| `check_number.sh` | If-elif-else with numeric comparisons |
| `file_check.sh` | File existence check with `-f` flag |
| `server_check.sh` | Combined script - variables + read + if-else + command substitution |

---

## What I Learned
- **The Shebang Is Non-Negotiable** – `#!/bin/bash` tells the OS which interpreter to use and keeps behaviour consistent, especially with Bash-specific syntax.
- **Quotes Control Variable Expansion** – Double quotes expand `$VAR`; single quotes keep everything literal. Mixing them up leads to unexpected output.
- **`[ ]` Is a Command – Spacing Matters** – `[ $N -gt 0 ]` works, `[$N -gt 0]` fails. Spaces inside and around the brackets are required.
