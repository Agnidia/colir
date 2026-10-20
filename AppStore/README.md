# App Store listing

This directory stores the Colir listing in the layout used by the
[App Store Connect CLI (`asc`)](https://github.com/rorkai/App-Store-Connect-CLI).

| Path | Content | Managed with |
|---|---|---|
| `metadata/app-info/<locale>.json` | Name, subtitle, and privacy policy URL | `asc metadata` |
| `metadata/version/<version>/<locale>.json` | Description, keywords, promotional text, release notes, and URLs | `asc metadata` |
| `screenshots/<locale>/APP_DESKTOP/` | Mac screenshots, uploaded in file-name order | `asc screenshots` |
| `changelog.md` | Release history | by hand |

Locales: `en-US`, `uk`. App ID: `6471902188`. Platform: `MAC_OS`.

## Character limits

| Field | Limit |
|---|---|
| Name, subtitle | 30 |
| Promotional text | 170 |
| Keywords | 100, comma-separated |
| Description, What's New | 4000 |

Run this check after each metadata change:

```sh
asc metadata validate --dir AppStore/metadata
```

## Fields outside `asc metadata`

The current listing uses these App Store Connect values:

| Field | Value |
|---|---|
| Age rating | 4+ |
| Primary category | Graphics & Design |
| Secondary category | Photo & Video |
| Copyright | Agnidia 2008 - 2026 |
| App Store URL | https://apps.apple.com/us/app/colir-folder-customizer/id6471902188 |

`asc metadata` does not manage these fields. Update copyright with
`asc versions update --version-id <VERSION_ID> --copyright "Agnidia 2008 - 2026"`.

## Screenshots

Store each locale's Mac screenshots in its `APP_DESKTOP` directory. Validate each set before upload:

```sh
asc screenshots validate --path AppStore/screenshots/en-US/APP_DESKTOP --device-type APP_DESKTOP
asc screenshots validate --path AppStore/screenshots/uk/APP_DESKTOP --device-type APP_DESKTOP
```

Upload one locale at a time. Use `--replace --confirm` only when the local directory contains the complete set.

```sh
asc screenshots upload --app 6471902188 --version <VERSION> --platform MAC_OS --locale en-US --path AppStore/screenshots/en-US/APP_DESKTOP --device-type APP_DESKTOP --replace --confirm
asc screenshots upload --app 6471902188 --version <VERSION> --platform MAC_OS --locale uk --path AppStore/screenshots/uk/APP_DESKTOP --device-type APP_DESKTOP --replace --confirm
```

## Publish a version

1. Create the version if it does not exist:
   `asc versions create --app 6471902188 --version <VERSION> --platform MAC_OS`.
2. Pull the live listing:
   `asc metadata pull --app 6471902188 --version <VERSION> --platform MAC_OS --dir AppStore/metadata`.
3. Validate the local files:
   `asc metadata validate --dir AppStore/metadata`.
4. Review the planned changes:
   `asc metadata plan --app 6471902188 --version <VERSION> --platform MAC_OS --dir AppStore/metadata`.
5. Apply the approved changes:
   `asc metadata apply --app 6471902188 --version <VERSION> --platform MAC_OS --dir AppStore/metadata --confirm`.
6. Check readiness:
   `asc validate --app 6471902188 --version-id <VERSION_ID>`.
7. Submit the matching build:
   `asc review submit --app 6471902188 --version <VERSION> --build-number <BUILD> --confirm`.

The submitted build number must match `CURRENT_PROJECT_VERSION` in `Configurations/base.xcconfig`.
