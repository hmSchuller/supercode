# Supercode

An opinionated [OpenCode](https://opencode.ai) profile built around [Superpowers](https://github.com/obra/superpowers).

Three primary agents (`lite`, `standard`, `pro`) share the same workflow prompt but use different models. Built-in `build` and `plan` agents are disabled.

## Features

- **Superpowers plugin** — brainstorming, planning, TDD, subagent-driven development
- **Tiered primaries** — `lite` (mimo), `standard` (minimax m3), `pro` (gpt-5.5)
- **Custom subagents** — `runner`, `review`, tuned `explore`
- **Custom commands** — `/commit`
- **Workflow overrides** — no worktrees by default, end-only review, post-plan test coverage audit

## Install

### One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/hmSchuller/supercode/main/install.sh | bash
source ~/.zshrc
```

### Local / from clone

```bash
git clone git@github.com:hmSchuller/supercode.git ~/dev/privat/supercode
cd ~/dev/privat/supercode
chmod +x install.sh
./install.sh
source ~/.zshrc
```

`./install.sh` copies the profile to `~/.config/supercode` and adds env vars to your shell.

### Manual

```bash
git clone git@github.com:hmSchuller/supercode.git ~/.config/supercode

# add to ~/.zshrc:
export OPENCODE_CONFIG="$HOME/.config/supercode/opencode.jsonc"
export OPENCODE_CONFIG_DIR="$HOME/.config/supercode"
```

## Prerequisites

- [OpenCode](https://opencode.ai) installed
- Auth for `opencode-go` (lite, standard, explore, runner)
- Auth for `openai` if you use the `pro` agent

```bash
opencode auth
```

## Environment variables

See [`.env.example`](.env.example). At minimum, set `OPENAI_API_KEY` for the `pro` tier.

## Usage

```bash
opencode
```

- **Tab** — cycle primary agents (`lite` → `standard` → `pro`)
- **Default** — `lite`
- **`@review`** — final consolidated code review
- **`@runner`** — cheap implementation subagent

## Structure

```text
supercode/
├── opencode.jsonc      # main config
├── prompts/primary.txt # shared primary agent prompt
├── agents/             # custom subagents
├── commands/           # slash commands
├── skills/             # optional bundled skills
├── install.sh
└── AGENTS.md           # delegation conventions
```

## Update

```bash
cd ~/.config/supercode && git pull
```

Or re-run `./install.sh` from a fresh clone.

## Uninstall

Remove the `# supercode opencode profile` block from your shell rc, then:

```bash
rm -rf ~/.config/supercode
```

Your existing `~/.config/opencode/opencode.json` is untouched.

## License

MIT
