# Nikahin App - Project Knowledge & Agent Guidelines

## 1. Project Overview
- **Name**: Nikahin App
- **Type**: Standalone Mobile Application (Android & iOS) for Wedding Planning & Budget Management.
- **Repository**: `rivaldiekaptrrr/nikahin_app`
- **Architecture**: Offline-First with Drift (SQLite) as the single source of truth.
- **Design System**: Material 3 + Bento Grid Layout.
- **Language & Strings**: Strictly in Indonesian for user-facing UI.

---

## 2. Tech Stack & Dependencies
- **Framework**: Flutter (SDK `^3.13.5` / `3.47.6+`) & Dart 3
- **State Management**: Flutter Riverpod
- **Local Persistence**: Drift (SQLite) + `sqlite3_flutter_libs`
- **Routing**: GoRouter
- **Documents & Sharing**: `pdf`, `printing`, `share_plus`
- **Security**: `local_auth` (Biometric & PIN lock)
- **Preferences**: `shared_preferences`
- **In-App Updater**: `package_info_plus`, `open_filex`, and GitHub Releases REST API

---

## 3. Directory Structure (`lib/`)
- `lib/app/`: Configuration, router definitions (`app_router.dart`), theme setup, and platform toggles (`platform_config.dart`).
- `lib/data/`: Drift SQLite tables, DAOs, repositories, and remote sync services.
- `lib/domain/`: Domain models, entities, and business logic enums.
- `lib/features/`: Feature-first modular components:
  - `auth/`: Biometric & PIN lock protection.
  - `budget/`: Itemized expense tracking and payment terms (Belum Bayar, DP, Lunas).
  - `committee/`: Panitia management & uniform/fabric distribution.
  - `dashboard/`: Countdown D-Day, quick stats, romantic quotes.
  - `documents/`: KUA & Civil registration legal checklists.
  - `guests/`: Guest list, classification, RSVP & CSV export.
  - `rundown/`: Multi-event chronological timeline & PIC assignment.
  - `seserahan/`: Hantaran status & packing checklist.
  - `settings/`: App theme, backup/restore, updater, reminders.
  - `tasks/` & `vendors/`: Task checklists & vendor directories.
- `lib/shared/`: Formatters, reusable Bento cards, dialogs, and PDF guidebook generators.
- `lib/ui/theme/`: Colors, typography, and Bento Grid tokens.

---

## 4. CI/CD & Release Workflow
- **Workflow**: Automated GitHub Actions in `.github/workflows/multiplatform-build.yml`.
- **Golden Rule**: Always run local validation before pushing or tagging:
  1. `flutter analyze`
  2. `flutter test`
  3. `flutter build apk --release`
- **Push to `main`/`master`**: Builds internal APK artifact (`app-nikahin-main.apk`) without publishing a GitHub Release.
- **Pushing tag `v*` (e.g. `v1.0.0`)**: Automatically creates a GitHub Release, attaches the release APK, and uses `RELEASE_NOTES.md` as the changelog.

---

## 5. Knowledge Graph & MCP Memory
Knowledge graph data and MCP configurations are versioned inside `.agents/`:
- `.agents/mcp_config.json`: Automatic MCP Memory & Maestro server registration.
- `.agents/knowledge_graph.json`: Machine-readable snapshot of entities and relations.
- `.agents/skills/flutter-environment-setup/SKILL.md`: Complete environment setup, toolchain requirements, and new machine onboarding guide.
- `.agents/skills/flutter-cicd-release-workflow/SKILL.md`: Detailed CI/CD and release workflow guide.
- `.agents/skills/maestro-testing/SKILL.md`: Complete Maestro E2E automated UI testing & MCP integration guide.
- `.agents/skills/clean-response-formatting/SKILL.md`: Standar penulisan format respon bersih, bebas dari raw LaTeX syntax ($...$, \rightarrow).
- `docs/MAESTRO_AND_EMULATOR_SETUP_GUIDE.md`: Complete guide for Android Emulator (CLI without Android Studio) and Maestro MCP testing.
