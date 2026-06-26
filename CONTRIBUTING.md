# Contributing to the CachyOS & Hermes Agent Guide

Thank you for your interest in improving this guide! Contributions from the community help keep these notes accurate, clean, and highly optimized for everyone.

## How to Contribute

### 1. Hardware Profiles
If you have a system configuration that runs CachyOS with local LLMs (Ollama) particularly well (or requires specific tweaks to get GPU acceleration working), we'd love to add it to our hardware profiles!
- Please edit the `README.md` to add your profile under the **5. Hardware Profiles** section.
- Include your system specs (CPU, GPU, RAM), driver installation commands, and any special environment variables.

### 2. Custom Hermes Agent Skills
This repository hosts custom agent skills under the `skills/` directory.
To contribute a new skill:
1. Create a subdirectory under `skills/` named after your skill (e.g. `skills/my_new_skill/`).
2. Include a `SKILL.md` file in that directory. The `SKILL.md` should use standard Hermes skill frontmatter containing the name and description:
   ```yaml
   ---
   name: my_new_skill
   description: Explains what this skill triggers on and does
   ---
   ```
3. Provide the executable bash instructions or prompts in the body of the skill.

### 3. General Enhancements & Tweaks
If you find outdated package names, better kernel parameters, gaming tweaks, or filesystem mount options:
- Fork the repository.
- Create a feature branch.
- Submit a Pull Request detailing the changes, the rationale behind them, and how you verified them.

## Repository Hygiene & Standards
- Keep documentation clear, concise, and focused on performance.
- Avoid committing large binary assets (like raw screenshots or high-resolution PNGs). Prefer native Markdown representations (such as Mermaid diagrams) or highly compressed SVG files.
- Double-check any shell commands or installation steps before committing.
