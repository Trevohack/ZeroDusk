
# Process Monitoring with pspy and Snoopy 

## Overview
When analyzing a Linux system (especially in incident response, digital forensics, or privilege escalation scenarios), monitoring processes and commands in real-time is extremely valuable.  
Two lightweight tools for this are:

- **pspy** → Monitors running processes, including those executed by other users, without requiring root.  
- **snoopy** → Logs all executed commands system-wide via PAM (Pluggable Authentication Modules).

---

## 1. pspy

### What is pspy?
`pspy` is a process monitoring tool that allows you to see **commands run by other users**, **cron jobs**, and **system processes** in real time — without needing root privileges.

### Key Features
- No root required  
- Detects scheduled tasks (cron jobs, systemd timers)  
- Shows parent/child process relationships  
- Useful for privilege escalation discovery

### Usage
1. Download the latest binary from the [pspy releases page](https://github.com/DominicBreuker/pspy).  
2. Give it execution permissions:  
```bash
chmod +x pspy 
./pspy 
```

## 2. Snoopy

### What is Snoopy?

- snoopy is a tiny library that logs every executed command through the execve() syscall. It integrates with PAM and sends logs to syslog (/var/log/auth.log or /var/log/secure depending on distro).

Key Features
1. Logs all executed commands (including arguments)
2. Integrates seamlessly with syslog
3. Helps detect malicious activity, persistence, or insider threats

