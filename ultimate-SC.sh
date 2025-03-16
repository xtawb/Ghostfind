#!/bin/bash
# ================================================
# ANSI Colors and Banner Design
# ================================================
MAGENTA='\033[95m'
DARK_RED='\033[31m'
LIGHT_RED='\033[91m'
GREEN='\033[92m'
YELLOW='\033[93m'
CYAN='\033[96m'
WHITE='\033[97m'
RESET='\033[0m'
# GHOSTFIND Banner
echo -e "${DARK_RED}
    \e[1mＧＨＯＳＴＦＩＮＤ${RESET} ${WHITE}
        		${MAGENTA}by${RESET} \e[1m${CYAN}@xtawb${RESET}${DARK_RED}
${RESET}"
echo -e "${LIGHT_RED}Advanced Reconnaissance Framework${RESET} ${GREEN}v1.0${RESET}"
echo -e "${MAGENTA}Contact: ${CYAN}https://linktr.ee/xtawb${RESET}"
echo -e "${MAGENTA}Github : ${CYAN}https://github.com/xtawb${RESET}"

# ================================================
# Dependency Installation
# ================================================
install_tool() {
    tool=$1
    echo -e "\n${YELLOW}[+] Checking for $tool...${RESET}"
    if ! command -v "$tool" &>/dev/null; then
        echo -e "${DARK_RED}[!] Installing $tool...${RESET}"
        
        case $tool in
            "nuclei")
                sudo apt-get install -y nuclei
                nuclei -update-templates >/dev/null 2>&1
                ;;
            "subfinder")
                sudo apt-get install -y subfinder
                ;;
            "amass")
                sudo apt-get install -y amass
                ;;
            "httpx-toolkit")
                sudo apt-get install -y httpx-toolkit
                ;;
            "gowitness")
                sudo apt-get install -y gowitness
                ;;
            "spyhunt.py")
                git clone https://github.com/gotr00t0day/spyhunt.git /tmp/spyhunt
                cp /tmp/spyhunt/spyhunt.py /usr/local/bin/
                pip3 install --break-system-packages -r /tmp/spyhunt/requirements.txt >/dev/null 2>&1
                sudo python3 /tmp/spyhunt/install.py >/dev/null 2>&1
                chmod +x /usr/local/bin/spyhunt.py
                ;;
            "nikto")
                sudo apt-get install -y nikto
                ;;
            "wapiti")
                sudo apt-get install -y wapiti
                ;;
            "sqlmap")
                sudo apt-get install -y sqlmap
                ;;
            "dirb")
                sudo apt-get install -y dirb
                ;;
            "whatweb")
                sudo apt-get install -y whatweb
                ;;
            "blc")
                sudo npm install -g broken-link-checker
                ;;
            *)
                echo -e "${DARK_RED}[ERROR] Unknown tool: $tool${RESET}"
                exit 1
                ;;
        esac
        echo -e "${GREEN}[✓] $tool installed successfully${RESET}"
    fi
}

# Install Required Tools
REQUIRED_TOOLS=("nuclei" "subfinder" "amass" "httpx-toolkit" "gowitness" "spyhunt.py" "nikto" "wapiti" "sqlmap" "dirb" "whatweb" "blc")
for tool in "${REQUIRED_TOOLS[@]}"; do
    install_tool "$tool"
done

# ================================================
# Input Handling
# ================================================
echo -e "\n${WHITE}▌ Select Input Type ▌${RESET}"
echo -e "${CYAN}1) Use existing subdomains file"
echo -e "2) Scan new domain${RESET}"
read -p "Your choice [1-2]: " INPUT_CHOICE

if [ "$INPUT_CHOICE" == "1" ]; then
    read -p "Enter full path to subdomains file: " SUBDOMAIN_PATH
    if [ ! -f "$SUBDOMAIN_PATH" ]; then
        echo -e "${DARK_RED}[ERROR] File not found!${RESET}"
        exit 1
    fi
    MODE="preloaded"
    cp "$SUBDOMAIN_PATH" ./subdomains_$(date +%F).txt
    DOMAIN_FILE="subdomains_$(date +%F).txt"
else
    read -p "Enter target domain: " DOMAIN
    if [ -z "$DOMAIN" ]; then
        echo -e "${DARK_RED}[ERROR] Domain cannot be empty!${RESET}"
        exit 1
    fi
    MODE="new"
    
    # Ask if the user wants to enumerate subdomains
    read -p "Do you want to enumerate subdomains? [Y/n]: " ENUM_SUBDOMAINS
    ENUM_SUBDOMAINS=${ENUM_SUBDOMAINS:-Y}  # Default to 'Y' if no input
fi

# ================================================
# Main Scan Workflow
# ================================================
OUTPUT_DIR="GHOSTFIND_Scan_$(date +%F_%H-%M-%S)"
echo -e "\n${CYAN}[+] Creating output directory: $OUTPUT_DIR ${RESET}"
mkdir -p "$OUTPUT_DIR" || { echo -e "${DARK_RED}[ERROR] Failed to create output directory!${RESET}"; exit 1; }

run_scan() {
    # Subdomain Enumeration (Only if user chose to enumerate subdomains)
    if [ "$MODE" == "new" ] && [[ "$ENUM_SUBDOMAINS" =~ [Yy] ]]; then
        echo -e "\n${CYAN}▌ Phase 1/10: Subdomain Enumeration ▌${RESET}"
        subfinder -d "$DOMAIN" -o "$OUTPUT_DIR/subdomains_raw.txt"
        amass enum -passive -d "$DOMAIN" >> "$OUTPUT_DIR/subdomains_raw.txt"
        sort -u "$OUTPUT_DIR/subdomains_raw.txt" -o "$OUTPUT_DIR/subdomains.txt"
    else
        echo -e "\n${CYAN}▌ Skipping Subdomain Enumeration ▌${RESET}"
        echo "$DOMAIN" > "$OUTPUT_DIR/subdomains.txt"
    fi

    # Live Domain Check
    echo -e "\n${CYAN}▌ Phase 2/10: Live Domain Verification ▌${RESET}"
    httpx-toolkit -l "$OUTPUT_DIR/subdomains.txt" -o "$OUTPUT_DIR/live_domains.txt"

    # Nuclei Scanning
    echo -e "\n${CYAN}▌ Phase 3/10: Vulnerability Scanning ▌${RESET}"
    nuclei -t ~/nuclei-templates/ \
        -l "$OUTPUT_DIR/live_domains.txt" \
        -severity critical,high \
        -o "$OUTPUT_DIR/nuclei_report.txt"

    # Spyhunt Advanced Scans
    echo -e "\n${CYAN}▌ Phase 4/10: Advanced Reconnaissance ▌${RESET}"
    spyhunt.py \
        --s3-scan \
        --cidr-scan \
        --jwt-scan \
        -i "$OUTPUT_DIR/live_domains.txt" \
        -o "$OUTPUT_DIR/Spyhunt_Reports"

    # Nikto Scanning
    echo -e "\n${CYAN}▌ Phase 5/10: Web Server Scanning ▌${RESET}"
    nikto -h "$DOMAIN" -output "$OUTPUT_DIR/nikto_report.html"

    # Wapiti Scanning
    echo -e "\n${CYAN}▌ Phase 6/10: Web Application Scanning ▌${RESET}"
    wapiti -u "https://$DOMAIN" -o "$OUTPUT_DIR/wapiti_report"

    # SQL Injection Scanning
    echo -e "\n${CYAN}▌ Phase 7/10: SQL Injection Scanning ▌${RESET}"
    sqlmap -u "https://$DOMAIN" --batch --output-dir="$OUTPUT_DIR/sqlmap_report"

    # Directory Brute Forcing
    echo -e "\n${CYAN}▌ Phase 8/10: Directory Brute Forcing ▌${RESET}"
    dirb "https://$DOMAIN" -o "$OUTPUT_DIR/dirb_report.txt"

    # WhatWeb Scanning
    echo -e "\n${CYAN}▌ Phase 9/10: Technology Detection ▌${RESET}"
    whatweb "https://$DOMAIN" --log-verbose="$OUTPUT_DIR/whatweb_report.txt"

    # Broken Link Check
    echo -e "\n${CYAN}▌ Phase 10/10: Broken Link Check ▌${RESET}"
    blc --filter-level 3 -roEe "https://$DOMAIN" > "$OUTPUT_DIR/broken_links.txt"

    # Create the final report
    echo -e "\n${CYAN}▌ Generating Consolidated Report ▌${RESET}"
    echo "GHOSTFIND Scan Report - $(date)" > "$OUTPUT_DIR/final_report.txt"
    echo "by @xtawb" >> "$OUTPUT_DIR/final_report.txt"
    cat "$OUTPUT_DIR"/*.txt >> "$OUTPUT_DIR/final_report.txt" 2>/dev/null

    # View the final report path
    echo -e "\n${GREEN}▌ Scan Completed Successfully ▌${RESET}"
    echo -e "${WHITE}Report Directory: ${MAGENTA}$(pwd)/$OUTPUT_DIR${RESET}"
    echo -e "${DARK_RED}Need Professional Cybersecurity Services? ${MAGENTA}https://linktr.ee/xtawb${RESET}"
}

# run_scan
run_scan
