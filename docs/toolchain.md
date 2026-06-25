# Toolchain Management

EcoBlocks has two product lines with different constraints. Do not force them to share one toolchain.

## Product Lines

| Line | Location | Toolchain policy |
| --- | --- | --- |
| Modern Android Hub | `app/` | Flutter + current Android Gradle Plugin + LTS JDK |
| Legacy low-memory route | `agent/embedded/` | Separate native Android/API19 route if revived |
| Blockly UI | `ui/blocks/` | npm lockfile + compiled JavaScript bundle |
| Shared core | `agent/core/` | Pure Dart package, no Flutter dependency |

## Modern Android Baseline

The modern Flutter app should use an LTS JDK as its baseline.

Current policy:

- Runtime JDK: JDK 21.
- Java bytecode target: Java 8 for broad Android compatibility.
- Gradle: pinned by `app/android/gradle/wrapper/gradle-wrapper.properties`.
- Android Gradle Plugin and Kotlin plugin: pinned in `app/android/settings.gradle`.
- Android SDK and NDK versions: declared in `app/android/gradle/libs.versions.toml`.

JDK 25 LTS is the preferred future target. JDK 26 can be tested in an experiment profile, but should not be the default baseline because it is not an LTS release.

## Compatibility Ranges

Record compatibility as ranges in documentation, then pin exact versions in build files.

Current verified window:

| Area | Range | Current pin | Notes |
| --- | --- | --- | --- |
| Runtime JDK for current Gradle | `17.x~21.x` | `21` | Gradle 8.7 can run on JDK 21; AGP 8.x needs modern JDKs, so do not go below 17. |
| Java/Kotlin bytecode target | `1.8~17` | `1.8` | Keep output conservative for Android device compatibility. |
| Gradle wrapper | `8.7~8.x` | `8.7` | Flutter 3.44 requires Gradle 8.7 or newer. Upgrade further only with AGP/Flutter checks. |
| Android Gradle Plugin | `8.1.x~8.x` | `8.2.1` | AGP 8.2.1 avoids the JDK 21 jlink/sourceCompatibility issue seen with AGP 8.1.0. |
| Kotlin Gradle plugin | `1.9.x~2.x` | `1.9.0` | Must match AGP and Gradle, not upgraded alone. |
| Flutter native plugins | plugin-specific verified range | `flutter_inappwebview: ^6.1.5` | Upgraded after Flutter 3.44.2 / Dart 3.12.2 verification. |
| Flutter filesystem plugin | `2.1.0~2.1.5` | `path_provider >=2.1.0 <2.1.6` | Hold below 2.1.6 while modern Android minSdk is 21. |
| Node.js for Blockly | `24.x LTS` | local developer install | Use the current LTS line for JS tooling. |
| NDK | exact pin only | `28.2.13676358` | Use the installed NDK to avoid SDK Manager download stalls. |

Future modern LTS target:

| Area | Target range | Gate |
| --- | --- | --- |
| Runtime JDK | `21.x~25.x LTS` | JDK 25 requires Gradle 9.1+ for officially supported Gradle runtime. |
| Gradle wrapper | `9.1~9.x` | Needed before making JDK 25 the default runtime. |
| AGP/Kotlin | matching AGP 9.x/Kotlin range | Must be checked against Flutter stable and Android release notes first. |

Legacy/API19 range:

| Area | Range |
| --- | --- |
| Runtime JDK | `8~17`, selected by the legacy Android Gradle Plugin |
| Gradle/AGP | independent old compatible range, not inherited from the modern app |
| UI | native Android/WebView, no full modern Flutter/Blockly promise |

When a range is not verified from official compatibility notes, write `verify before change` instead of guessing.

## Version Ownership

Use one owner for each version.

| Version | Owner file |
| --- | --- |
| Gradle distribution | `app/android/gradle/wrapper/gradle-wrapper.properties` |
| Android Gradle Plugin | `app/android/settings.gradle` |
| Kotlin Gradle plugin | `app/android/settings.gradle` |
| `compileSdk` | `app/android/gradle/libs.versions.toml` |
| modern `minSdk` | `app/android/gradle/libs.versions.toml` |
| `targetSdk` | `app/android/gradle/libs.versions.toml` |
| Java source/target level | `app/android/gradle/libs.versions.toml` |
| NDK version | `app/android/gradle/libs.versions.toml` |
| Flutter package versions | `app/pubspec.yaml` and `app/pubspec.lock` |
| Dart core package versions | `agent/core/pubspec.yaml` |
| Blockly npm versions | `ui/blocks/package-lock.json` |

## Flutter Plugin Policy

Treat Flutter plugins that contain native Android/iOS code as toolchain-coupled dependencies.

Examples:

- `flutter_inappwebview`
- camera/media plugins
- Bluetooth/USB/serial plugins
- database plugins with native binaries

These packages must be checked against:

- Flutter SDK range.
- Dart SDK range.
- Android `minSdk`, `compileSdk`, and `targetSdk`.
- AGP and Gradle range.
- Kotlin plugin range if the plugin has Kotlin Android code.
- AndroidX dependency changes.

For `flutter_inappwebview`, the project uses `^6.1.5`. This was verified on Flutter 3.44.2 / Dart 3.12.2. The 6.1.x line requires Dart `^3.5.0`, Flutter `>=3.24.0`, Android `minSdkVersion >= 19`, `compileSdk >= 34`, and AGP `>=7.3.0`. EcoBlocks has Android `minSdk 21`, `compileSdk 34`, and AGP `8.2.1`.

Verified range:

| Package | Range | Gate |
| --- | --- | --- |
| `flutter_inappwebview` | `6.1.x~6.1.x` | Flutter `>=3.24.0`, Dart `^3.5.0`, Android compileSdk `34+`, AGP `7.3+` |

Do not use old namespace patch scripts with `flutter_inappwebview` 6.x. The 6.x Android package has its own namespace; old scripts that hard-code a 5.8.0 cache path are stale.

Do not upgrade native plugins together with unrelated UI or docs changes. Make one dependency upgrade commit, run the app, and keep the rollback obvious.

## Flutter 3.44 Run Notes

The following issues were found while running the modern app with Flutter 3.44.2 / Dart 3.12.2.

| Issue | Symptom | Fix |
| --- | --- | --- |
| l10n import path | `package:flutter_gen/gen_l10n/...` does not exist. | Import `package:ecoblocks_app/l10n/app_localizations.dart` and generate localization files into `lib/l10n`. |
| synthetic l10n package | `synthetic-package` is removed in modern Flutter. | Do not rely on `package:flutter_gen`; use project-local l10n output. |
| `flutter_inappwebview` 5.x | Fails on removed v1 embedding APIs such as `PluginRegistry.Registrar`. | Use `flutter_inappwebview ^6.1.5`. |
| AGP 8.1.0 + JDK 21 | jlink/sourceCompatibility failure. | Use AGP `8.2.1` while staying on the Gradle 8.x line. |
| Gradle 8.5 + Flutter 3.44 | Flutter rejects the Android build because the wrapper is below its minimum supported Gradle 8.7. | Use Gradle wrapper `8.7`. |
| JDK 25 + Gradle 8.x | Flutter plugin loader metadata only accepts Java 21 on the current baseline. | Use JDK 21 for the current baseline. JDK 25 requires a later Gradle/AGP move. |
| NDK auto-download | SDK Manager stalls while preparing missing NDK 25.1. | Pin `ndkVersion` to installed `28.2.13676358`. |

## Current Dependency Watchlist

These are the versions most likely to affect buildability or Android device coverage.

| Dependency | Current range | Latest checked | Action |
| --- | --- | --- | --- |
| `flutter_inappwebview` | `6.1.x~6.1.x` | `6.1.5` stable, `6.2.0-beta.3` prerelease | Current verified line. Avoid beta unless there is a specific WebView bug. |
| `path_provider` | `2.1.0~2.1.5` | `2.1.6` | Hold `<2.1.6`; latest 2.1.6 raises minimum supported SDK to Flutter 3.38/Dart 3.10 and latest docs show Android support SDK 24+. |
| `intl` | Flutter-managed | `0.20.2` | Keep `any` because `flutter_localizations` constrains it. Only pin if the solver becomes unstable. |
| `http` | `1.2.x~1.x` | `1.6.0` | Safe major range for pure Dart core; verify if moving to `2.x`. |
| `test` | `1.24.x~1.x` | `1.31.1` | Safe major range for pure Dart tests; verify browser/test runner changes before `2.x`. |
| `blockly` | `11.x~11.x` | `13.0.0` | Do not auto-upgrade; 12/13 are major Blockly migrations. |
| `webpack` | `5.90.x~5.x` | `5.107.2` | Stay on webpack 5. |
| `webpack-cli` | `5.1.x~5.x` | `7.0.3` | Keep 5.x unless intentionally moving the JS toolchain; latest 7.x needs Node `>=20.9`. |
| `copy-webpack-plugin` | `12.x~12.x` | `14.0.0` | Keep 12.x unless intentionally moving the JS toolchain; latest 14.x needs Node `>=20.9`. |
| `html-webpack-plugin` | `5.6.x~5.x` | `5.6.7` | Current major is fine. |

## Upgrade Grouping

Group upgrades by blast radius:

- Flutter runtime group: Flutter SDK, Dart SDK, `flutter_inappwebview`, `path_provider`, `flutter_localizations`, `intl`.
- Android build group: JDK, Gradle wrapper, AGP, Kotlin plugin, compileSdk, targetSdk, NDK.
- Blockly toolchain group: Node LTS, npm, Blockly, webpack, webpack-cli, HTML/copy plugins.
- Pure Dart core group: `agent/core` SDK constraint, `http`, `test`.

Never mix all four groups in one commit unless the repository is being intentionally rebased onto a new full toolchain baseline.

## NDK Policy

The NDK version is pinned in the version catalog even if the current app does not use native C/C++ yet.

The modern app currently sets `ndkVersion` to `28.2.13676358` because that version is installed on the validation machine and avoids a stalled download of Flutter's default NDK. If another machine does not have this version, install the pinned NDK rather than letting Gradle select a different one.

## Flutter Locks

For applications, commit lockfiles for reproducibility.

- `app/pubspec.lock` should be committed once Flutter dependencies are resolved locally.
- `agent/core` is a reusable package, so it may follow Dart package convention and omit `pubspec.lock`.

## Cache Policy

EcoBlocks no longer requires a repository `setenv.sh` bootstrap step. Build
machines may use the default Flutter, Gradle, pub, and npm cache locations, or
configure their own cache policy outside the repo.

## Upgrade Rule

Upgrade in this order:

1. Read Flutter, AGP, Gradle, Kotlin, JDK, Node, and NDK compatibility notes from official sources.
2. Record the compatible range in this document, using `x.y~x.y` or `x.x LTS` style.
3. Pick one exact pinned version inside that range.
4. Update the single owner file for the exact version.
5. Run the modern app build and Blockly build.
6. Update this document if the verified range or baseline changes.
7. Keep the legacy/API19 route independent.

## Compatibility Sources

Check these before changing first-class toolchain versions:

- Gradle compatibility matrix: <https://docs.gradle.org/current/userguide/compatibility.html>
- Android Gradle Plugin release notes: <https://developer.android.com/build/releases/gradle-plugin>
- Oracle Java SE support roadmap: <https://www.oracle.com/java/technologies/java-se-support-roadmap.html>
- Node.js releases: <https://nodejs.org/en/about/previous-releases>
- Flutter release notes: <https://docs.flutter.dev/release/release-notes>
- pub.dev package pages and changelogs: <https://pub.dev/>
- npm registry metadata: <https://www.npmjs.com/>
