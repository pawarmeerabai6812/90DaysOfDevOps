#!/bin/bash
 
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
 
# Main section: call both functions and print results
# ── Main ──────────────────────────────────────────────
echo "==============================="
echo "  System Resource Check Report "
echo "==============================="
echo ""

check_disk
check_memory

echo "Report complete."