# BlackHat Bash Toolkit - Advanced Version

## Overview

The BlackHat Bash Toolkit is a comprehensive, menu-driven Bash script designed for ethical hacking labs. It provides a unified interface to common pentesting tools, with built‑in logging, dependency checks, and colorized output for clarity.

---

## Prerequisites

Before using the toolkit, ensure you have the following:

* **Operating System**: Debian‑based Linux (e.g., Ubuntu, Kali)
* **Bash**: Version 4+ (default on modern Linux distros)
* **Root Privileges**: Required for installing dependencies and certain modules (e.g., keylogger simulation)

### Dependencies

The script automatically checks for—and can install—the following tools:

| Tool           | Purpose                             |
| -------------- | ----------------------------------- |
| `nmap`         | Network & port scanning             |
| `whois`        | Domain WHOIS lookups                |
| `nikto`        | Web vulnerability scanner           |
| `sqlmap`       | Automated SQL injection tests       |
| `hydra`        | SSH brute‑force attacks             |
| `searchsploit` | Local CVE/exploit database searches |
| `john`         | Password hashing/cracking           |
| `showkey`      | Keylogger simulation via scancodes  |

> **Note**: The installer prompt appears if any of the above are missing.

---

## Installation

1. **Download the script**:

   ```bash
   git clone https://github.com/ShiboshreeRoy/blackhat-toolkit.git
   cd blackhat-toolkit
   ```
2. **Make it executable**:

   ```bash
   chmod +x blackhat_toolkit.sh
   ```
3. **Run** (may prompt to install missing packages):

   ```bash
   sudo ./blackhat_toolkit.sh
   ```

Upon launch, the script will:

1. Check and optionally install missing dependencies (requires root).
2. Create or append to `blackhat_toolkit.log`.
3. Display the interactive menu.

---

## Usage

### Launching

```bash
sudo ./blackhat_toolkit.sh
```

### Menu Navigation

* Enter the **number** corresponding to the desired tool.
* Follow on‑screen prompts for target IPs, hostnames, URLs, file paths, etc.
* After each action, press **Enter** to return to the main menu.

### Exiting

Select option **13** or press **Ctrl+C** at any time.

---

## Module Descriptions

1. **Network Scanner**

   * Discovers live hosts in a CIDR range using `nmap -sn`.

2. **Port Scanner**

   * Performs port scans with customizable port ranges.

3. **OS Fingerprinting**

   * Estimates target OS via ICMP TTL values.

4. **Nmap Aggressive Scan**

   * Runs `nmap -A` for service/OS detection and script scans.

5. **WHOIS Lookup**

   * Retrieves domain registration information.

6. **Reverse Shell Generator**

   * Prints a Bash one‑liner for a reverse shell.

7. **Nikto Web Scanner**

   * Scans web servers for vulnerabilities.

8. **SQLMap Injection Test**

   * Automates SQL injection checks.

9. **Hydra SSH Brute‑Force**

   * Attempts SSH login via password lists.

10. **Search CVE (searchsploit)**

    * Queries Exploit‑DB for known vulnerabilities.

11. **Keylogger (Simulation)**

    * Demonstrates keylogging scancodes (root only).

12. **Hash Cracker (John)**

    * Cracks hashed passwords with John the Ripper.

---

## Log File

All actions, timestamps, and errors are logged to:

```
./blackhat_toolkit.log
```

Use this for auditing and troubleshooting.

---

## Troubleshooting

* **Permission Denied**: Ensure the script is executable (`chmod +x`) and run with `sudo` if prompted.
* **Missing Commands**: Rerun the installer prompt or manually install via:

  ```bash
  sudo apt update && sudo apt install nmap whois nikto sqlmap hydra exploitdb john showkey
  ```
* **Invalid Input**: Follow on‑screen format hints (e.g., `192.168.1.0/24`, `http://example.com?id=1`).

---

## Contributing

Feel free to submit issues or pull requests on GitHub. Please adhere to ethical guidelines and only use this toolkit in authorized environments.

---

## License

Distributed under the MIT License. See `LICENSE` for details.

---

**Author:** Shiboshree Roy

**Date:** May 31, 2025
