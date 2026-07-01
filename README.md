# Supercode

An opinionated [OpenCode](https://opencode.ai) profile built around [Superpowers](https://github.com/obra/superpowers).

Three primary agents (`lite`, `standard`, `pro`) share the same workflow prompt but use different models. Built-in `build` and `plan` agents are disabled. Supercode is meant to provide a preconfigured workflow that allows you to do serious development work at a fraction of the costs of the higher end frontier subscriptions.

Needed subscriptions:
- `opencode-go` (lite, standard, explore, runner) - 10$ / month
- `ChatGPT Plus` (pro) - 20$ / month
- `Brave Search` (optional, for web search) - 5000 queries / month free after registering

## Features

- **Superpowers plugin** — brainstorming, planning, TDD, subagent-driven development
- **Tiered primaries** — `lite` (mimo), `standard` (minimax m3), `pro` (gpt-5.5)
- **Custom subagents** — `runner`, `review`, tuned `explore`
- **Custom commands** — `/commit`
- **Workflow overrides** — no worktrees by default, end-only review, post-plan test coverage audit

## Common Questions

### Why is the plan agent disabled?
By using superpowers, naturally describing tasks is enough to trigger the `brainstorming` skill which will start a spec driven planning process. 

### What's the difference between the primary agents?
The more powerful the agent, the more capable it is handling the tasks you throw at it.

- `lite` is the default agent and uses the `mimo-v2.5` model. It's dirt cheap. There's no way you will ever run into usage limits with this one.
- `standard` uses the `minimax-m3` model. It's more powerful than `lite` and very cost efficient. I recommend using this one for most more complex tasks. It's not set as default because escalating up is usually the more cost effective way to go.
- `pro` uses the `gpt-5.5` model. Needless to say, it wipes the floor with the other two, but you will quickly drain your usage limits with this one. Expect 2 - 3 feature per 5 hour usage window. 

### Why is there a custom commit command?
I've found it to be very helpful. It works by checking the staged changes and generating a commit for it. You can invoke this during any point in your session, with any primary agent as it always spawns a cheap subagent to do the work.

### What's the reasoning for tweaking superpowers' default settings?
- Worktrees: In theory nice, often times unnecessary. When you need them, tell the agent to use them.
- Review: Superpower's default review cycle is very thorough. I found it to be overkill for most tasks. Skipping the review cycle between tasks and doing a consolidated review at the end proved to have the same level of quality but with a lower wall time.
- Test coverage audit: Spawning a dedicated subagent to audit the test coverage after the plan has been created proved to be very helpful. It helps you catch missing edge cases and ensures that you have a good test coverage. This is done while you review the plan anyway.

### Using other models
You can switch to other models by editing the `opencode.jsonc` file. The models are configured in the `agent` section, or using the `/model` command. Good substitutes for `lite` are `deepseek-v4-flash`. They're prolly equally capable, I have found `mimo-v2.5` to be better at following instructions.
For `standard`, `minimax-m3` is one hell of a model. You can also use `mimo-v2.5-pro` or `deepseek-v4-pro` here, but I have found `minimax-m3` to be more reliable and cost effective.
For `pro`, you can switch to `gpt-5.4` if you want to get more mileage out of your usage limits. It's stated that `gpt-5.5` is more expensive but token efficient. Honestly, I am rarely using `pro` so I couldn't tell much of a difference. 

**What about `glm-5.2`?** Honestly, I do not see a usecase for `glm-5.2` in this workflow. I've found `minimax-m3` to be equally performant, while costing a fraction. In cases where `minimax-m3` is not enough, `glm-5.2` wasn't any better.

**By sticking to the suggested models for `lite` and `standard`, you will have a hard time reaching your usage limits.**

## Getting the most out of your `pro` limit
Use `pro` for features where you are architecturally completely lost and need to figure out the best way to implement it. If you a tackling a completely novel problem, you should use `pro` to get a sense of the best way to approach it
Once a spec and implementation plan has been created, you can switch to a cheaper agent to implement it. `standard` is capable to handle any implementation task.


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
