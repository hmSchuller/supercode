---
name: brave-search
description: |
  Use when the user asks to search the web, look something up online, fetch current information, or research a topic.
  Provides instructions for using the Brave Search API to get web, news, and video results via curl/bash.
  Do NOT use for local file lookups, codebase searches, or repository-internal questions.
---

# Brave Search

Search the web using the [Brave Search API](https://brave.com/search/api/).

## Setup

1. Sign up for a free API key at https://api.search.brave.com/app/dashboard
   (free tier: 2,000 queries/month)
2. Store the key in an environment variable:

```bash
export BRAVE_API_KEY="YOUR_API_KEY"
```

Add it to your shell profile (`~/.zshrc`, `~/.bashrc`) or opencode's config env.

## Usage

### Web Search

```bash
curl -s "https://api.search.brave.com/res/v1/web/search?q=QUERY&count=10" \
  -H "Accept: application/json" \
  -H "Accept-Encoding: gzip" \
  -H "X-Subscription-Token: $BRAVE_API_KEY"
```

Parameters:
- `q` (required): search query
- `count` (optional, 1–20, default 10): number of results
- `offset` (optional, default 0): pagination
- `safesearch` (optional): `off`, `moderate`, `strict` (default `moderate`)
- `freshness` (optional): `pd` (past 24h), `pw` (past week), `pm` (past month), `py` (past year)

### News Search

```bash
curl -s "https://api.search.brave.com/res/v1/news/search?q=QUERY&count=10" \
  -H "Accept: application/json" \
  -H "Accept-Encoding: gzip" \
  -H "X-Subscription-Token: $BRAVE_API_KEY"
```

Same parameters as web search, plus:
- `extra_news` (boolean): include extra news snippets
- `spellcheck` (integer 0 or 1)

### Video Search

```bash
curl -s "https://api.search.brave.com/res/v1/videos/search?q=QUERY&count=10" \
  -H "Accept: application/json" \
  -H "Accept-Encoding: gzip" \
  -H "X-Subscription-Token: $BRAVE_API_KEY"
```

Same parameters as web search, plus:
- `freshness` also available
- `spellcheck` (integer 0 or 1)

### Image Search

```bash
curl -s "https://api.search.brave.com/res/v1/images/search?q=QUERY&count=10" \
  -H "Accept: application/json" \
  -H "Accept-Encoding: gzip" \
  -H "X-Subscription-Token: $BRAVE_API_KEY"
```

## Response Format

All endpoints return JSON. Key fields in web search results:

```
web.results[].{title, url, description, age, language}
web.family_friendly — boolean
web.type — "search"
```

## Best Practices

- Always set `Accept-Encoding: gzip` for smaller responses.
- Use `freshness` when the user asks about current events or recent info.
- Limit `count` to 5–10 for most queries; increase only if needed.
- Summarize the results in natural language — don't dump raw JSON.
- If a result seems stale, re-query with `freshness=pd`.
- Handle missing `$BRAVE_API_KEY` gracefully: tell the user they need an API key from https://api.search.brave.com/app/dashboard.
- When the user says "search the web" or "look up" something, use this skill.
