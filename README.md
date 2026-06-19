# Omarchy Personal

Personal CachyOS overlay on [basecamp/omarchy](https://github.com/basecamp/omarchy) **dev** (4.0 alpha). Keeps omarchy naming and paths; see [`PERSONAL.md`](PERSONAL.md) for decisions and rebase workflow.

## Quick start

```bash
git clone git@github.com:happypurpleduck/omarchy.git
cd omarchy
git remote add upstream git@github.com:basecamp/omarchy.git  # if missing
./scripts/verify.sh
./boot.sh
```

## Rebase onto upstream

```bash
git fetch upstream
git rebase upstream/dev
./scripts/apply-personal-overlay.sh
./scripts/verify.sh
```

## Updates on an installed system

`omarchy update` pulls Omarchy config from this fork (`happypurpleduck/omarchy`, branch `dev`) and updates system packages via pacman/paru. Fork git settings live in `config/omarchy/fork.conf`.

## License

Omarchy is released under the [MIT License](https://opensource.org/licenses/MIT).
