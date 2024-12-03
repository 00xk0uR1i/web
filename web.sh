#!/bin/bash

# Colors for output
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

# Display script author and animated intro
function show_intro() {
  clear
  echo "######################################################"
  echo "#                                                    #"
  echo "#   Web Pentesting Toolkit by k0ur1i                #"
  echo "#   Version: 1.1                                    #"
  echo "#   Date: $(date +%Y-%m-%d)                         #"
  echo "#                                                    #"
  echo "######################################################"
  echo ""
  echo "Initializing Web Pentesting Toolkit..."
  sleep 1
  echo -n "["
  for i in $(seq 1 30); do
    echo -n "="
    sleep 0.05
  done
  echo "]"
  echo -e "${GREEN}Ready to begin!${RESET}"
  echo ""
}

# Usage information
function show_usage() {
  echo "Usage: $0 [-t target] [-f target_file]"
  echo "Options:"
  echo "  -t target       Specify a single target to attack (e.g., http://example.com)"
  echo "  -f target_file  Provide a file with a list of targets, one per line."
  echo "Example: $0 -t http://example.com"
  echo "Example: $0 -f targets.txt"
  exit 1
}

# Parse command-line arguments
SINGLE_TARGET=""
TARGET_FILE=""

while getopts "t:f:" opt; do
  case $opt in
    t) SINGLE_TARGET="$OPTARG" ;;
    f) TARGET_FILE="$OPTARG" ;;
    *) show_usage ;;
  esac
done

if [ -z "$SINGLE_TARGET" ] && [ -z "$TARGET_FILE" ]; then
  show_usage
fi

MAIN_LOG_DIR="web_pentest_logs_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$MAIN_LOG_DIR"

# Function to test SQL Injection
function sql_injection() {
  TARGET=$1
  LOG_FILE="$MAIN_LOG_DIR/sql_injection.txt"
  echo "Testing for SQL Injection on $TARGET" | tee -a "$LOG_FILE"
  PAYLOAD="' OR '1'='1"
  RESPONSE=$(curl -s -G --data-urlencode "username=$PAYLOAD" "$TARGET")
  if echo "$RESPONSE" | grep -qi "error"; then
    echo -e "${GREEN}[VULNERABLE]${RESET} SQL Injection detected on $TARGET" | tee -a "$LOG_FILE"
  else
    echo -e "${RED}[NOT VULNERABLE]${RESET} No SQL Injection vulnerability detected on $TARGET" | tee -a "$LOG_FILE"
  fi
}

# Function to test XSS
function xss_tests() {
  TARGET=$1
  LOG_FILE="$MAIN_LOG_DIR/xss_tests.txt"
  echo "Testing for XSS on $TARGET" | tee -a "$LOG_FILE"
  PAYLOAD="<script>alert('XSS')</script>"
  RESPONSE=$(curl -s -G --data-urlencode "search=$PAYLOAD" "$TARGET")
  if echo "$RESPONSE" | grep -q "$PAYLOAD"; then
    echo -e "${GREEN}[VULNERABLE]${RESET} XSS detected on $TARGET" | tee -a "$LOG_FILE"
  else
    echo -e "${RED}[NOT VULNERABLE]${RESET} No XSS vulnerability detected on $TARGET" | tee -a "$LOG_FILE"
  fi
}

# Function to enumerate subdomains
function subdomain_enum() {
  TARGET=$1
  DOMAIN=$(echo "$TARGET" | awk -F[/:] '{print $4}')
  LOG_FILE="$MAIN_LOG_DIR/subdomain_enum.txt"
  echo "Enumerating subdomains for $DOMAIN" | tee -a "$LOG_FILE"
  subfinder -d "$DOMAIN" | tee -a "$LOG_FILE"
}

# Function to test for file upload vulnerabilities
function file_upload_test() {
  TARGET=$1
  LOG_FILE="$MAIN_LOG_DIR/file_upload.txt"
  echo "Testing for file upload vulnerabilities on $TARGET" | tee -a "$LOG_FILE"
  RESPONSE=$(curl -s -F "file=@test.php" "$TARGET/upload")
  if echo "$RESPONSE" | grep -qi "success"; then
    echo -e "${GREEN}[VULNERABLE]${RESET} File upload vulnerability detected on $TARGET" | tee -a "$LOG_FILE"
  else
    echo -e "${RED}[NOT VULNERABLE]${RESET} No file upload vulnerability detected on $TARGET" | tee -a "$LOG_FILE"
  fi
}

# Function to discover hidden parameters
function hidden_param_discovery() {
  TARGET=$1
  LOG_FILE="$MAIN_LOG_DIR/hidden_param_discovery.txt"
  echo "Discovering hidden parameters for $TARGET" | tee -a "$LOG_FILE"
  paramspider -d "$TARGET" | tee -a "$LOG_FILE"
}

# Main function to run all tests
function run_tests() {
  TARGET=$1
  echo "Starting tests on $TARGET"
  sql_injection "$TARGET"
  xss_tests "$TARGET"
  subdomain_enum "$TARGET"
  file_upload_test "$TARGET"
  hidden_param_discovery "$TARGET"
}

# Display intro
show_intro

# Execute tests
if [ -n "$SINGLE_TARGET" ]; then
  run_tests "$SINGLE_TARGET"
elif [ -n "$TARGET_FILE" ] && [ -f "$TARGET_FILE" ]; then
  while IFS= read -r TARGET; do
    if [ -n "$TARGET" ]; then
      run_tests "$TARGET"
    fi
  done < "$TARGET_FILE"
else
  echo "Target file not found or invalid!"
  exit 1
fi

echo "All tests completed. Logs are stored in $MAIN_LOG_DIR."
