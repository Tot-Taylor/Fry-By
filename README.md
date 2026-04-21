# AI Repo Starter Kit

This starter kit gives you a multi-file AI context system for software projects.

## Main idea
You only need to invoke:

- `/ai/AI_ENTRY.md`

The AI should then:
- ask careful questions
- create or expand the other AI files only when needed
- keep the full system synchronized
- stay lightweight for small projects
- grow into architecture, tasks, decisions, and prompt packs for larger projects

## Included files

### Core orchestrator
- `ai/AI_ENTRY.md`

### Supporting context files
- `ai/PROJECT_SPEC.md`
- `ai/ARCHITECTURE.md`
- `ai/TASKS.md`
- `ai/DECISIONS.md`
- `ai/PROMPTS.md`
- `ai/SCAFFOLDING.md`

### Claude-optimized prompt packs
- `ai/prompts/claude-session-kickoff.md`
- `ai/prompts/feature-implementation.md`
- `ai/prompts/refactor-planning.md`
- `ai/prompts/bug-investigation.md`
- `ai/prompts/task-expansion.md`
- `ai/prompts/scaffold-generation.md`

## Recommended repo placement

Place the entire `ai/` folder at the root of your project repo.

## Typical usage

### Starting a new project
Tell the AI:
> Read `/ai/AI_ENTRY.md` and initialize this repo's AI files for my project idea.

### Continuing work later
Tell the AI:
> Read `/ai/AI_ENTRY.md` and continue from the current repo AI context.

### Implementing a feature
Tell the AI:
> Read `/ai/AI_ENTRY.md` and help me implement [feature].

## Design principles
- one entrypoint
- cautious question-first workflow
- progressive documentation
- scalable task generation
- Claude-friendly prompt structure
- reusable scaffolding guidance
