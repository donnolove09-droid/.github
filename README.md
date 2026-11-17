# ASNLIGHT – GitHub Actions / Theos UI-only project

This repository is a buildable starter for an iOS Theos tweak containing the ASNLIGHT floating launcher and rounded black/red menu UI.

## Included
- `Tweak.xm` – UIKit overlay with ESP UI, Aimbot UI, and Information tabs.
- `Makefile` – Theos build configuration.
- `ASNLIGHT.plist` – target bundle filter.
- `.github/workflows/build.yml` – GitHub Actions build workflow.
- `Resources/asnlight-avatar.jpg` – supplied brand image (kept as a project asset; this minimal UI sample currently uses text initials on the floating button).

## Build on GitHub
1. Create a new GitHub repository.
2. Upload the contents of this folder to the repository root.
3. Commit to the `main` branch, or open **Actions → Build ASNLIGHT UI dylib → Run workflow**.
4. When the workflow finishes, download the `ASNLIGHT-build` artifact.

## Scope and limitation
This is deliberately a **UI-only** sample. It does not include game-memory reading, ESP tracking, aimbot, Silent Aim, AimKill, damage manipulation, or game-function hooks. The ESP/Aimbot entries are labels for visual layout only and do not affect gameplay. The original `aimkill.h` and `Offsets.h` are not copied into this build project.

The GitHub workflow builds a Theos package (`.deb`); the tweak's compiled dynamic library is included in the build output when the build succeeds. A `.deb` is not an IPA and does not automatically install or sign an app for a non-jailbroken device.
