---
name: cachyos_system_info
description: Check optimization status, kernel parameters, scheduler settings, and basic hardware performance statistics of CachyOS.
---

# CachyOS System Info Skill

This skill teaches the Hermes Agent how to inspect the status of CachyOS-specific kernels and optimizations on the host system.

## Triggering Phrases
* "Check CachyOS system performance profile"
* "Verify active kernel scheduler and CPU governor"
* "Show the current system configuration and optimizations"

## Instructions

When the user asks you to check system optimization settings or check CachyOS-specific configurations, run the following commands to inspect the state and report it back to the user:

1. **Check the active Kernel release:**
   ```bash
   uname -r
   ```
   *(Expected output includes `-cachyos` or `-cachyos-bore`)*

2. **Check the CPU governor settings:**
   ```bash
   cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
   ```
   *(Commonly `performance` or `schedutil`)*

3. **Check the default network congestion control algorithm:**
   ```bash
   sysctl net.ipv4.tcp_congestion_control
   ```
   *(CachyOS defaults to `bbr` for optimal throughput)*

4. **Verify if BTRFS is used and display mount optimizations:**
   ```bash
   mount | grep btrfs
   ```

5. **Provide a summarized report to the user:**
   Present this information in a cleanly styled Markdown table showing the setting name, current system value, and brief explanation.
