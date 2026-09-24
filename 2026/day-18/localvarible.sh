#!/bin/bash
#
# local_demo.sh (simple version)
#
# Analogy: think of "my_var" as a whiteboard.
#   - Without 'local'  -> everyone shares ONE whiteboard in the hallway.
#   - With 'local'     -> you bring your own whiteboard into a room,
#                          use it, and throw it away when you leave.
#                          The hallway whiteboard is never touched.

echo "=== STEP 1: Set the outer (hallway) variable ==="
my_var="Hello from OUTSIDE"
echo "my_var is now: $my_var"
echo ""

# -----------------------------------------------------------------
# FUNCTION 1: uses 'local' -> changes stay INSIDE the function only
# -----------------------------------------------------------------
change_with_local() {
    local my_var="Hello from INSIDE (local)"
    echo "   [inside function] my_var = $my_var"
}

echo "=== STEP 2: Call the function that uses 'local' ==="
change_with_local
echo "my_var is now: $my_var"
echo "   --> Notice it's STILL 'Hello from OUTSIDE'. The function's"
echo "       local variable was thrown away after the function ended."
echo ""

# -----------------------------------------------------------------
# FUNCTION 2: no 'local' -> changes LEAK OUT and overwrite the outer var
# -----------------------------------------------------------------
change_without_local() {
    my_var="Hello from INSIDE (no local)"
    echo "   [inside function] my_var = $my_var"
}

echo "=== STEP 3: Call the function that does NOT use 'local' ==="
change_without_local
echo "my_var is now: $my_var"
echo "   --> Notice it CHANGED to 'Hello from INSIDE (no local)'."
echo "       Without 'local', the function edited the SAME outer variable."
echo ""

echo "=== Done ==="