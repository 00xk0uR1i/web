
# Web Pentesting Toolkit

## Author
**k0ur1i**  
Version: 1.1  


## Overview
This toolkit automates web pentesting tasks, running a variety of tests against specified web targets. It now includes enhanced techniques like SQL Injection, XSS Testing, Subdomain Enumeration, File Upload Testing, and Hidden Parameter Discovery.

---

## Features
1. **SQL Injection Testing**: Detects common SQL injection vulnerabilities.
2. **Cross-Site Scripting (XSS) Testing**: Identifies potential XSS vulnerabilities.
3. **Subdomain Enumeration**: Lists subdomains for a target domain.
4. **File Upload Testing**: Verifies if the server accepts file uploads.
5. **Hidden Parameter Discovery**: Finds hidden or undocumented parameters.

---

## Prerequisites
Install these tools before running the script:
- `curl`: Used for testing requests.
- `subfinder`: For subdomain enumeration.
- `paramspider`: For discovering hidden parameters.

### Install Commands
```bash
sudo apt install curl
sudo apt install subfinder
git clone https://github.com/devanshbatham/ParamSpider.git
cd ParamSpider
pip install -r requirements.txt
```

---

## Usage
### Script Options
- **Single Target**: Test a single target URL.
  ```bash
  ./web.sh -t http://target.com
  ```
- **Multiple Targets**: Test multiple URLs listed in a file (`targets.txt`).
  ```bash
  ./web.sh -f targets.txt
  ```

### Example File Format for `targets.txt`
Each line should contain a single target URL. Example:
```
http://taget1.com
https://target2.com
```

---

## Log Output
- Logs are stored in a directory named `web_pentest_logs_<timestamp>`.
- Separate log files are created for each test category (e.g., `sql_injection.txt`, `xss_tests.txt`).

---

## Disclaimer
This script is for educational purposes and authorized testing only. Unauthorized use of this toolkit against systems you do not own or have permission to test may violate laws and regulations.

---

## Author's Note
This tool is a starting point for pentesters to streamline their assessments. Modify and expand it as needed to suit specific environments.

---

**Created with ❤️ by k0ur1i**
