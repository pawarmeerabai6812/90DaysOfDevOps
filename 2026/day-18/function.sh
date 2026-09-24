unctions · SH
#!/bin/bash
 
# Function to greet a person by name
greet() {
    local name="$1"
    echo "Hello, $name!"
}
 
# Function to add two numbers
add() {
    local num1="$1"
    local num2="$2"
    local sum=$((num1 + num2))
    echo "$sum"
}
 
# Call the functions
greet "World"
add 5 10