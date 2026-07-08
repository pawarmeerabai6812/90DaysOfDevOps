# Day 06 – Linux Fundamentals: Read and Write Text Files

## Overview ##
Today's focus is on mastering basic file operations that every DevOps engineer uses daily. You'll learn to create, write, read, and manipulate text files using essential Linux commands.

## 1. Create a File ##

```bash
touch day6.txt
```
What it did: 
- Creates a new empty file called day6.txt. If the file already exists, it just updates the timestamp - it did NOT delete the content.

## 2. Write to a File (Overwrite)##

```bash
echo "Today is Day 6/90 of my DevOps journey" > day6.txt
```

it used to write text into a file. If the file doesn't exist, it creates it. If the file already exists, it overwrites its contents.
echo:
- echo is a Linux command used to display or print text.

##  3. Append to a File ##

```bash
echo "Linux append the file" >> day6.txt
```
Explanation:

- appends content to the file

- Existing content is saved

##  4. Write and Display Output Using tee ##

```bash
echo "Linux is backbone of Devops " | tee -a day6.txt

```

Explanation:

- tee -displays output on the terminal

- -a -appends the output to the file

##  5. Display the file Content  ##

```bash
cat day6.txt

```
## 6. Add Multiple Lines Using EOF##

```bash
cat <<EOF >> day6.txt
cat reads full file
head reads top lines
tail reads bottom lines
These skills help in DevOps
EOF

```

Explanation:

- EOF is a multi-line input method
- Appends multiple lines at once

## 7. View Top Lines (head)##
```bash
head day6.txt

```

```bash
head -n 2 day6.txt

```
Explanation:

- Shows the first 10 lines by default
- -n specifies number of lines

## 8. View Bottom Lines (tail)## 

```bash
tail -n 2 day6.txt

```

Explanation:
- Displays the last 2 lines of the file.

## 8. Search for word ## 
```bash
grep "Linux" day6.txt

```
Explanation:

- Searches for the word Linux in day6.txt and displays the matching line(s).





















