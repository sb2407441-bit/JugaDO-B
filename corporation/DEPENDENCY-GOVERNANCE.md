# Dependency and capability governance

## Default

Investigate first. A new dependency is justified only when built-in tools and current installed
packages cannot meet a documented requirement.

## Required approval record

Before installation, capture: purpose, source/repository, version or revision, license/security
considerations, scope (workspace environment vs. system), expected files/network access, test,
and rollback command. Prefer the project `.venv` or project-local tool directory.

## Prohibited without explicit user approval

- system-wide package managers or PATH edits
- browser extensions, social login, cookie import/export, or credentials
- MCP server registration and remote endpoints
- background daemons, deployment, commits, pushes, payments, and destructive commands

## After any approved install

Run the narrow health check, record the installed version, verify one intended use, and report
what remains unavailable. Never claim a channel works merely because a package installed.
