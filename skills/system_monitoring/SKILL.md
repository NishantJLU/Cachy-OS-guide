---
name: system_monitoring
description: Monitor system resource usage (CPU, RAM, GPU) and active processes on CachyOS.
---

# System Monitoring Skill

This skill teaches the Hermes Agent how to monitor active system hardware loads on CachyOS.

## Triggering Phrases
* "Show my system resource usage"
* "Is my GPU currently being utilized by Ollama?"
* "List the top CPU-consuming processes"

## Instructions

When the user requests resource utilization data or asks about system loads, run the following commands to gather metrics:

1. **Check Memory (RAM & Swap) usage:**
   ```bash
   free -h
   ```

2. **Check System Load & CPU utilization:**
   ```bash
   uptime
   # Or get the top CPU-consuming processes
   ps -eo pid,cmd,%mem,%cpu --sort=-%cpu | head -n 10
   ```

3. **Check GPU utilization:**
   - **For NVIDIA GPUs:**
     ```bash
     nvidia-smi --query-gpu=utilization.gpu,utilization.memory,temperature.gpu,memory.used,memory.total --format=csv
     ```
   - **For AMD GPUs:**
     ```bash
     cat /sys/class/drm/card0/device/gpu_busy_percent 2>/dev/null || echo "ROCm GPU telemetry not available directly via sysfs."
     ```

4. **Verify if Ollama is running active processes:**
   ```bash
   pgrep -fl ollama
   ```

5. **Provide a summarized report to the user:**
   Report the active memory pool details, CPU load factors, and GPU telemetry details back in a clear, formatted summary.
