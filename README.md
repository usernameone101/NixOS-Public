# NixOS Flake Collection

A curated collection of NixOS flake files designed to streamline complex software deployments, development environments, and security research workflows.

## Overview

This repository serves as a central hub for reusable NixOS flakes. Each flake is version-pinned and optimized for reproducible environments, ranging from specialized security tools to production-grade system configurations.

## Featured Use Cases

### 1. Security & Research Tools
Pre-configured flakes for specialized security software, including kernel fuzzers and vulnerability analysis tools. These are designed to handle complex dependencies and system-level requirements (e.g., specific kernel headers or KVM support).

### 2. Development Shells (`nix develop`)
Language-specific development environments (Rust, Go, C++, Python) with all necessary toolchains, linters, and libraries pre-loaded. 

### 3. Virtualization & QEMU
Configurations for managing virtualized environments, including custom QEMU scripts and NixOS-based VM images for testing software in isolation.

### 4. Infrastructure & Server Modules
Pluggable NixOS modules for common services, hardened for security and performance.

## Getting Started

### Using a Development Shell
```bash
nix develop github:username/nixos-flakes#env-name
