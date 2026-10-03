# Favad Thottathil: Portfolio

[![CI/CD](https://github.com/favadthottathil/portfolio-flutter-web/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/favadthottathil/portfolio-flutter-web/actions/workflows/ci-cd.yml)
[![Link check](https://github.com/favadthottathil/portfolio-flutter-web/actions/workflows/link-check.yml/badge.svg)](https://github.com/favadthottathil/portfolio-flutter-web/actions/workflows/link-check.yml)

A single-page portfolio built with Flutter Web, deployed on Vercel:
<https://portfolio-favad-ts-projects.vercel.app>

## Develop

```bash
flutter pub get
flutter run -d chrome
flutter analyze && flutter test
```

The Flutter version is pinned in [`.fvmrc`](.fvmrc). With [FVM](https://fvm.app),
run `fvm use` to match it.

Content (experience, projects, skills) lives in the `lib/features/*/*_data.dart`
files. See [`CLAUDE.md`](CLAUDE.md) for the architecture and the
scroll-performance rules.

## CI/CD

Every PR is formatted, analyzed, tested, built, size-checked and smoke-tested
in a real browser before it can deploy. See [`docs/CI_CD.md`](docs/CI_CD.md).
