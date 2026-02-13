# Coding Rules & Preferences

Guidelines for LLM-assisted development in this project.

## Project Structure

- Custom code lives in `lib/`
- `settings.rb` at project root is the shared configuration—load it first in any entry point
- Use `make` commands for common tasks (see Makefile)
- Gems are vendored locally in `vendor/bundle/`

## Ruby Style

- Use `frozen_string_literal: true` pragma in all Ruby files
- Prefer explicit `require_relative` over autoloading
- Keep classes and modules small and focused

## Code Quality

- Run `make lint` before committing
- Run `make test` to ensure tests pass
- Write specs for new functionality in `spec/`

## Feature Development

- Feature specifications live in `docs/features/`
- Each feature should have its own markdown file describing requirements and behavior
