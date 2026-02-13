# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

**Before writing code, read:**
- `docs/RULES.md` — coding preferences and style guidelines
- `docs/features/` — feature specifications

## Project Overview

A Ruby CLI tool for exploring the chronology of the "70 weeks" prophecy in Daniel 9 using rigorous, transparent day-count arithmetic. The tool's purpose is clarity, reproducibility, and honest reporting—not dogmatic date-setting.

## Build & Development Commands

```bash
make install    # Install dependencies
make test       # Run tests
make lint       # Run rubocop
make lint-fix   # Auto-fix lint issues
make run        # Run the CLI
make console    # IRB with settings.rb loaded

# Run a single test file
bundle exec rspec spec/path/to/spec.rb
```

## Architecture

### Project Structure Convention
- All custom code lives in `lib/`
- `settings.rb` at project root is the shared configuration file—always loaded first by any entry point (CLI, rake tasks, module requires)
- Entry points should `require_relative "settings"` before anything else

### Core Design Principle
Time is modeled as a continuous count of days using **Julian Day Numbers (JDN)**, enabling calculations to cross BC/AD boundaries without calendar artifacts.

### Calculation Flow
1. **Anchor dates**: Historically defensible dates for the decree of Artaxerxes (various proposed years in mid-5th century BC)
2. **Projection**: Forward 69 prophetic weeks using a 360-day year (173,880 days total)
3. **Output**: Results presented in multiple calendar representations (Julian, Gregorian, computed Hebrew)

### Calendar Representation Caveat
The ancient Hebrew calendar was observational—based on moon sighting and agricultural conditions. This tool does not claim to reconstruct lived calendrical declarations, only to show the unavoidable mathematical consequences of stated assumptions. Calendar outputs are strictly reference views.
