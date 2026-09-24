# Day 18 – Shell Scripting: Functions, Strict Mode & Scope

## Table of Contents
- [Overview](#overview)
- [Task 1 – Basic Functions](#task-1--basic-functions)
- [Task 2 – Functions with Return Values](#task-2--functions-with-return-values)
- [Task 3 – Strict Mode (`set -euo pipefail`)](#task-3--strict-mode-set--euo-pipefail)
- [Task 4 – Local Variables](#task-4--local-variables)
- [Task 5 – Build a Script: System Info Reporter](#task-5--build-a-script-system-info-reporter)
- [Concept Comparisons](#concept-comparisons)
- [Key Takeaways](#key-takeaways)
- [Summary](#summary)
- [Quick Reference Cheatsheet](#quick-reference-cheatsheet)

---

## Overview

| Concept | Purpose |
|---------|---------|
| `function_name() { ... }` | Group reusable commands into a named block |
| `$1`, `$2` inside a function | Accept arguments passed to a function |
| `set -e` | Exit immediately if any command fails |
| `set -u` | Treat unset variables as errors |
| `set -o pipefail` | Catch failures anywhere inside a pipeline |
| `local` | Scope a variable to the function it's declared in |

---

## Task 1 – Basic Functions

### 1. What is a shell function?
- A named, reusable block of commands. Defined once, called as many times as needed — just like a mini-script inside your script.

```bash
function_name() {
    # commands
}
```

### 2. `functions.sh` – greet and add 🎉

```bash
#!/bin/bash
# functions.sh
# Defines and calls two simple functions

# Function to greet a person by name
greet() {
    local name="$1"
    echo "Hello, $name! 👋"
}

# Function to add two numbers
add() {
    local num1="$1"
    local num2="$2"
    local sum=$((num1 + num2))
    echo "Sum: $sum"
}

echo "🔧 Function Demo"
echo "-------------------"

# Call the functions
greet "World"
add 5 10
```

Expected output:

```
🔧 Function Demo
-------------------
Hello, World! 👋
Sum: 15
```

### 3. What's happening
- `greet` reads its first argument (`$1`) as the name and prints a greeting.
- `add` reads two arguments, does arithmetic with `$((...))`, and echoes the result.
- Functions are **defined** first, then **called** by name at the bottom — defining a function does not run it.

---

## Task 2 – Functions with Return Values

### 1. Functions that "return" output
- Bash functions don't return values like other languages — they either `echo` output (captured by the caller) or set an `exit status` (`0` = success, non-zero = failure) checked via `$?`.

### 2. `disk_check.sh` – disk and memory report 💽

```bash
#!/bin/bash
# disk_check.sh
# Reports disk and memory usage using functions

# Function to check disk usage of root partition
check_disk() {
    echo "----- Disk Usage (/) -----"
    df -h /
}

# Function to check free memory
check_memory() {
    echo "----- Memory Usage -----"
    free -h
}

# ── Main ──────────────────────────────────────────────
echo "==============================="
echo "  📊 System Resource Check Report "
echo "==============================="
echo ""

check_disk
check_memory

echo ""
echo "✅ Report complete."
```

Actual output (EC2):

```
===============================
  📊 System Resource Check Report 
===============================

----- Disk Usage (/) -----
Filesystem      Size  Used Avail Use% Mounted on
/dev/root       6.7G  3.1G  3.6G  47% /
----- Memory Usage -----
               total        used        free      shared  buff/cache   available
Mem:           908Mi       375Mi       234Mi       2.8Mi       426Mi       532Mi
Swap:             0B          0B          0B

✅ Report complete.
```

### 3. Wrapper function vs. direct calls
Originally the calls were wrapped in a `main() { ... }` block followed by a `main` call:

```bash
main() {
    check_disk
    check_memory
}
main
```

**Important:** defining `main()` only registers it — nothing runs until `main` is actually called on its own line. Forgetting that final `main` call means the script runs silently with **zero output** (exit code `0`, no error). We simplified this script to call `check_disk` and `check_memory` directly instead of wrapping them.

---

## Task 3 – Strict Mode (`set -euo pipefail`)

### 1. Why strict mode? 🛡️
- By default, bash scripts keep running even after a command fails, or silently treat undefined variables as empty strings. `set -euo pipefail` turns those silent failures into loud, immediate stops.

### 2. `strict_demo.sh` – documented flag behavior

```bash
#!/bin/bash
# strict_demo.sh
# Demonstrates set -e, set -u, set -o pipefail
set -euo pipefail

echo "=== strict_demo.sh: set -euo pipefail ==="
echo ""

# Demo 1: set -u — undefined variable (commented out, would kill script)
# echo "Undefined var: $UNDEFINED_VAR"
echo "[Demo 1] set -u: would fail on \$UNDEFINED_VAR (see comments in script)"

# Demo 2: set -e — failing command (commented out, would kill script)
# ls /path/does/not/exist
echo "[Demo 2] set -e: would fail on 'ls /path/does/not/exist' (see comments)"

# Demo 3: pipefail — failure inside a pipeline (commented out)
# ls /path/does/not/exist | wc -l
echo "[Demo 3] pipefail: would fail on 'ls /nowhere | wc -l' (see comments)"

echo ""
echo "✅ Report complete."
```

Normal run output (demos commented out):

```
=== strict_demo.sh: set -euo pipefail ===

[Demo 1] set -u: would fail on $UNDEFINED_VAR (see comments in script)
[Demo 2] set -e: would fail on 'ls /path/does/not/exist' (see comments)
[Demo 3] pipefail: would fail on 'ls /nowhere | wc -l' (see comments)

✅ Report complete.
```

### 3. Verified behavior when each flag actually triggers

**`set -u`** — referencing `$UNDEFINED_VAR`:

```
Before
bash: line 1: UNDEFINED_VAR: unbound variable
Exit code: 1
```

**`set -e`** — running `ls /path/does/not/exist`:

```
Before
ls: cannot access '/path/does/not/exist': No such file or directory
Exit code: 2
```

**`set -o pipefail`** — running `ls /path/does/not/exist | wc -l`:
- *Without* `pipefail`: exit code `0` — the pipeline "succeeds" because only `wc -l`'s exit code counts, and `wc -l` happily counts 0 lines. `ls`'s failure is **hidden**. ❌
- *With* `pipefail`: exit code `2` — the failure correctly propagates and the script stops. ✅

### 4. Flag reference

| Flag | What it does |
|------|---------------|
| `set -e` | Exits the script immediately if any command returns a non-zero exit status. |
| `set -u` | Treats unset/undefined variables as an error and exits, instead of silently substituting an empty string. |
| `set -o pipefail` | Makes a pipeline fail if **any** command in it fails, not just the last one. |

---

## Task 4 – Local Variables

### 1. Local vs. global scope 🔒
- By default, a variable assigned inside a function is **global** — it's the same variable visible everywhere in the script. `local` confines a variable to just the function it's declared in.

> Analogy: think of a variable as a whiteboard. Without `local`, everyone shares one hallway whiteboard — any function can walk up and erase/rewrite it. With `local`, you bring your own whiteboard into the room and throw it away when you leave; the hallway one is never touched.

### 2. `local_demo.sh` – local vs global comparison

```bash
#!/bin/bash
# local_demo.sh
# Demonstrates local vs global variable scope

echo "=== STEP 1: Set the outer (hallway) variable ==="
my_var="Hello from OUTSIDE"
echo "my_var is now: $my_var"
echo ""

change_with_local() {
    local my_var="Hello from INSIDE (local)"
    echo "   [inside function] my_var = $my_var"
}

echo "=== STEP 2: Call the function that uses 'local' ==="
change_with_local
echo "my_var is now: $my_var"
echo ""

change_without_local() {
    my_var="Hello from INSIDE (no local)"
    echo "   [inside function] my_var = $my_var"
}

echo "=== STEP 3: Call the function that does NOT use 'local' ==="
change_without_local
echo "my_var is now: $my_var"
echo ""

echo "=== Done ==="
```

Output:

```
=== STEP 1: Set the outer (hallway) variable ===
my_var is now: Hello from OUTSIDE

=== STEP 2: Call the function that uses 'local' ===
   [inside function] my_var = Hello from INSIDE (local)
my_var is now: Hello from OUTSIDE

=== STEP 3: Call the function that does NOT use 'local' ===
   [inside function] my_var = Hello from INSIDE (no local)
my_var is now: Hello from INSIDE (no local)

=== Done ===
```

### 3. Key takeaway
`local` keeps a variable trapped inside its function; without it, the variable is shared globally, and any function can accidentally overwrite it — a common source of silent bugs in larger scripts.

---

## Task 5 – Build a Script: System Info Reporter

### 1. Goal 🎯
Combine everything from Tasks 1–4 into one function-based tool: functions for each report section, `set -euo pipefail` for safety, and a `main` function that ties it all together with section headers.

### 2. `system_info.sh`

```bash
#!/bin/bash
# system_info.sh
# Full system info reporter built from functions
set -euo pipefail

print_os_info() {
    echo "Hostname : $(hostname)"
    if [ -f /etc/os-release ]; then
        (
            . /etc/os-release
            echo "OS       : ${PRETTY_NAME:-Unknown}"
        )
    else
        echo "OS       : $(uname -s)"
    fi
    echo "Kernel   : $(uname -r)"
    echo "Arch     : $(uname -m)"
}

print_uptime() {
    uptime -p 2>/dev/null || uptime
}

print_disk_usage() {
    echo "Top 5 mounted filesystems by size:"
    df -h --output=source,size,used,avail,pcent,target 2>/dev/null \
        | tail -n +2 \
        | sort -k2 -h -r \
        | head -n 5
}

print_memory_usage() {
    free -h
}

print_top_processes() {
    echo "Top 5 processes by CPU usage:"
    ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6
}

main() {
    echo "==============================="
    echo "     🖥️  System Info Reporter"
    echo "==============================="
    echo ""

    echo "----- Hostname & OS -----"
    print_os_info
    echo ""

    echo "----- Uptime -----"
    print_uptime
    echo ""

    echo "----- Disk Usage (Top 5) -----"
    print_disk_usage
    echo ""

    echo "----- Memory Usage -----"
    print_memory_usage
    echo ""

    echo "----- Top 5 CPU Processes -----"
    print_top_processes
    echo ""

    echo "✅ Report complete."
}

main
```

### 3. Actual output (EC2)

```
===============================
     🖥️  System Info Reporter
===============================

----- Hostname & OS -----
Hostname : ip-172-31-28-128
OS       : Ubuntu 26.04 LTS
Kernel   : 7.0.0-1006-aws
Arch     : x86_64

----- Uptime -----
up 4 hours, 26 minutes

----- Disk Usage (Top 5) -----
Top 5 mounted filesystems by size:
/dev/root        6.7G  3.1G  3.6G  47% /
/dev/nvme0n1p13  989M  163M  760M  18% /boot
tmpfs            455M     0  455M   0% /tmp
tmpfs            455M     0  455M   0% /dev/shm
tmpfs            182M  944K  181M   1% /run

----- Memory Usage -----
               total        used        free      shared  buff/cache   available
Mem:           908Mi       365Mi       268Mi       2.8Mi       402Mi       543Mi
Swap:             0B          0B          0B

----- Top 5 CPU Processes -----
Top 5 processes by CPU usage:
    PID COMMAND         %CPU %MEM
   3049 containerd       0.1  2.3
      1 systemd          0.1  1.7
  39738 systemd          0.0  1.3
  32901 snapd            0.0  2.7
    607 dbus-daemon      0.0  0.5

✅ Report complete.
```

### 4. Function breakdown

| Function | Purpose |
|----------|---------|
| `print_os_info` | Hostname, OS name (via `/etc/os-release`), kernel, architecture |
| `print_uptime` | System uptime, falls back to plain `uptime` if `-p` unsupported |
| `print_disk_usage` | `df -h` output sorted by size, top 5 |
| `print_memory_usage` | `free -h` output |
| `print_top_processes` | `ps` sorted by `%CPU`, top 5 |
| `main` | Prints section headers and calls each function above in order |

---

## Concept Comparisons

### Function calling patterns

| Pattern | Runs immediately? | Risk |
|---------|--------------------|------|
| `greet() { ... }` then `greet "World"` | Yes, when called | None |
| `main() { ... }` defined but never called | **No** | Script runs with zero output, exit 0 — easy to miss |
| `main() { ... }; main` | Yes, at the `main` call | None |
| Direct calls with no wrapper | Yes, top to bottom | Slightly less organized for large scripts |

### `local` vs global variables

| Feature | `local` variable | Global (regular) variable |
|---------|-------------------|----------------------------|
| Scope | Confined to the function | Entire script |
| Survives after function ends | No — destroyed | Yes — persists |
| Risk | Low — safe to reuse names | High — can silently overwrite other variables |
| Best practice | Always use inside functions | Reserve for values meant to be shared |

### Strict mode flags

| Flag | Catches | Exit trigger |
|------|---------|---------------|
| `set -e` | Any failing command | Immediately on non-zero exit status |
| `set -u` | Undefined variables | Immediately on reference to unset var |
| `set -o pipefail` | Failures inside a pipeline | Immediately if any stage of a pipe fails |

---

## Key Takeaways

**1. Functions organize scripts, but defining ≠ running.**
A function block like `main() { ... }` only registers the function. Nothing executes until you call it by name — forgetting that call is a common, silent bug (no error, just no output).

**2. `local` is not optional inside functions.**
Any variable assigned inside a function without `local` becomes global and can silently overwrite a variable of the same name used elsewhere in the script — a classic source of hard-to-trace bugs in longer scripts.

**3. Strict mode turns silent failures into loud, immediate ones.**
`set -e`, `set -u`, and `set -o pipefail` together catch three very different failure modes: a failing command, an undefined variable, and a hidden failure buried inside a pipeline. Using all three together is the standard "strict mode" pattern for production-quality scripts.

---

## Summary

| Task | Script | Core Concept |
|------|--------|---------------|
| Task 1 | `functions.sh` | Defining and calling functions with arguments |
| Task 2 | `disk_check.sh` | Functions wrapping system commands; define vs. call |
| Task 3 | `strict_demo.sh` | `set -e`, `set -u`, `set -o pipefail` |
| Task 4 | `local_demo.sh` | Variable scope: `local` vs global |
| Task 5 | `system_info.sh` | Combining functions + strict mode into a full reporting tool |

Shell scripting skills unlocked today:
- Writing and calling reusable bash functions with arguments
- Understanding that defining a function doesn't execute it
- Using `set -euo pipefail` for defensive, production-safe scripts
- Correctly scoping variables with `local` to avoid silent bugs
- Structuring a multi-section tool around a single `main` function

---

## Quick Reference Cheatsheet

```bash
# ── FUNCTIONS ────────────────────────────────────────────
my_func() { echo "Hello, $1"; }   # define
my_func "World"                   # call — required to run it!

greet() {
    local name="$1"
    echo "Hi, $name"
}

add() {
    local sum=$(( $1 + $2 ))
    echo "$sum"
}

# ── STRICT MODE ──────────────────────────────────────────
set -euo pipefail
# -e           exit on any failing command
# -u           exit on undefined variable
# -o pipefail  catch failures inside pipelines

# ── LOCAL VS GLOBAL ──────────────────────────────────────
outer_var="global"
my_func() {
    local outer_var="local only"   # does NOT change the outer one
}
my_func2() {
    outer_var="changed"            # DOES change the outer one (no 'local')
}

# ── SYSTEM INFO COMMANDS ─────────────────────────────────
hostname                            # hostname
uname -r                            # kernel version
uptime -p                           # uptime, human readable
df -h /                             # disk usage of root
free -h                             # memory usage
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6   # top CPU processes
```