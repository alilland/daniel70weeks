# Daniel 70 Weeks

A Ruby CLI tool for exploring the chronology of the "70 weeks" prophecy in Daniel 9 using rigorous, transparent day-count arithmetic.

## Quick Start

```bash
make install    # Install dependencies
make run        # Run the CLI
make test       # Run tests
```

## Install Ruby + Run The App (Beginner-Friendly)

This project needs Ruby `>= 3.0.0`. If you have never installed Ruby before, follow these steps exactly.

**Step 1: Install Ruby**

Pick the instructions for your operating system.

**Windows**

1. Go to the official Ruby download page and follow the Windows instructions:

```text
https://www.ruby-lang.org/en/downloads/
```

2. The official Windows installer is RubyInstaller. The Ruby docs link to it from the installation page:

```text
https://www.ruby-lang.org/en/documentation/installation/
```

**macOS**

1. Install Ruby using `rbenv` (recommended). The official Ruby site lists `rbenv` as a supported tool for macOS:

```text
https://www.ruby-lang.org/en/downloads/
```

2. Install `rbenv` using the official installer script, then follow its instructions:

```text
https://github.com/rbenv/rbenv-installer
```

3. After `rbenv` is installed, install Ruby 3.2.2 (or any Ruby version `>= 3.0.0`):

```bash
rbenv install 3.2.2
rbenv global 3.2.2
```
**Linux**

1. Use your Linux distribution’s package manager (the official Ruby docs list examples for `apt`, `yum`, and `snap`):

```text
https://www.ruby-lang.org/en/documentation/installation/
```

2. If your distro’s Ruby is too old, use `rbenv` (same steps as macOS):

```text
https://github.com/rbenv/rbenv-installer
```

**Optional alternative (macOS/Linux): RVM**

If you prefer RVM, use the official installer instructions:

```text
https://rvm.io/rvm/install
```

**Step 2: Verify Ruby Installed**

Open Terminal (macOS/Linux) or Command Prompt / PowerShell (Windows) and run:

```bash
ruby -v
```

You should see a version `3.0.0` or higher.

**Step 3: Install The App’s Dependencies**

In the project folder, run:

```bash
bundle install
```

**Step 4: Run The App**

From the project folder, run:

```bash
ruby bin/daniel70weeks calculate "Nisan 1, 444 BC"
```

## Documentation

See [docs/](docs/README.md) for detailed documentation, coding guidelines, and feature specifications.
