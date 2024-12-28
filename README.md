# Fun Facts Microservices Application
A final project used for the following courses **Upskill 34 DevOps**  at **Telerik**:

## Branching strategy
For this repo I'm using Trunk Based Development (TBD) flow strategy, because:
> - Branch are small and self sufficiental;
> - Keep close to the `main` branch;
> - Reduce merge conflicts
> - Fast feedback loops for the CI part;
> - Quick release.

## Setup my own dev environment
### Create a simple tests for safeguards like: pre-commit hooks (linters, fixers),  AI coding assistant(copilot)  and etc.
***
> - check-yaml, end-of-file-fixer, check-added-large-files, check-merge-conflict, gitleaks, black and more.

## Continuous Integration (CI) Components
***
The CI workflow is defined in GitHub Actions.\
It is triggered on PR to a trunk branch in the repository,
ensuring that the codebase is continuously integrated and fully tested.

> - *Application* is set of three Docker containers. [More here in APP/README](app/README.md) with details.
> - Git Action workflow *app-ci-pipeline.yml*
> - Different type of checks: code quality and lint, hardcoded credentials, securety and others
> - Build Docker images
> - Upload to registry
> - [More here in CI_APP_README](.github/workflows/CI_APP_README.md) with details.
