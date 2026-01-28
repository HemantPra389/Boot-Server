# Server Bootstrap

A modular, interactive Bash-based server bootstrap installer for Ubuntu 20.04+.

## Features

- **Interactive Installer**: Easy-to-use terminal interface.
- **Modular**: Each package is handled by a separate script.
- **Idempotent**: Safe to run multiple times.
- **Non-Interactive Mode**: Supports configuration file for automated setpus.
- **Skip Logic**: Smart skipping of packages.

## Usage

### Interactive Mode (Default)

Run the installer with root privileges:

```bash
sudo ./install.sh
```

Follow the on-screen prompts to select which packages to install:
- **[Y]es**: Install the package.
- **[N]o**: Do not install.
- **[S]kip**: Skip and optionally skip all remaining packages.

### Non-Interactive Mode

You can run the installer non-interactively by providing a configuration file:

1. Create a `setup.conf` file (or use any name and pass `--config <file>`):

```bash
# setup.conf
INSTALL_DOCKER=true
INSTALL_NODE=true
INSTALL_NGINX=false
INSTALL_GIT=true
INSTALL_NGROK=true
```

2. Run the installer:

```bash
sudo ./install.sh --non-interactive --config setup.conf
```

### One-Liner

To run directly from a URL (if hosted):

```bash
curl -fsSL <your-repo-url>/install.sh | sudo bash
```

## Structure

- `install.sh`: Main entry script.
- `scripts/`: Contains individual package installation scripts.
    - `common.sh`: Common utilities and base setup.
    - `docker.sh`, `node.sh`, `nginx.sh`, `git.sh`, `ngrok.sh`: Package scripts.

## Requirements

- Ubuntu 20.04 or higher.
- Root (sudo) access.

## License

MIT
