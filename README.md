# tncli

Web-first workspace manager for multi-repo dev environments. Define
services, shared infrastructure, and per-branch workspaces in one
`tncli.yml`, then manage everything from a **browser dashboard** backed by
tmux, Docker, and git worktrees.

Running `tncli` starts a local web server (an xterm.js mirror of your tmux
panes) — start/stop services, watch live logs, shell into any pane, track
PRs, and create/delete isolated workspaces, all from the browser.

📖 **Full documentation:** https://toantran292.github.io/tncli-docs/

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/toantran292/tncli-releases/main/install.sh | bash
```

Update to the latest release:

```bash
tncli update
```

### Supported platforms

| Platform | Architecture | Binary |
|----------|-------------|--------|
| macOS | Apple Silicon (M1/M2/M3/M4) | `tncli-darwin-arm64` |
| macOS | Intel | `tncli-darwin-amd64` |
| Linux | x86_64 | `tncli-linux-amd64` |
| Linux | ARM64 | `tncli-linux-arm64` |

### Dependencies

- `tmux` (3.x+)
- `zsh`
- `git`
- `docker` (for shared services)

```bash
# macOS
brew install tmux

# Ubuntu/Debian
sudo apt install tmux zsh git
```

## Quick start

```bash
# 1. Create tncli.yml at your project root (see the docs)
# 2. One-time setup (gitignore + shared-service port pool)
tncli setup

# 3. Launch the web dashboard
tncli
```

`tncli` serves the dashboard on `http://0.0.0.0:8765` (reachable on your
LAN; use `tncli web --host 127.0.0.1` to keep it local). Open it in your
browser and manage services, workspaces, logs, and PRs from there.

## CLI

The browser is the primary surface; the rest is plain subcommands:

```bash
tncli                      # launch the web dashboard (default)
tncli web [--host --port]  # dashboard with an explicit bind
tncli workspace create <branch>   # spawn an isolated workspace (worktrees + DBs)
tncli workspace delete <branch>
tncli start|stop|restart|status [target]
tncli logs|attach <service>
tncli db reset|clean
tncli run <service> <cmd...>
tncli list · disk · migrate · setup · update · version · completion
```

See the [documentation](https://toantran292.github.io/tncli-docs/) for the
full `tncli.yml` reference (variables, environments, shared services,
port allocation) and guides.

## License

MIT
