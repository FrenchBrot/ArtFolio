# ArtFolio

3rd year Final term flutter project under 6ADET course. Documentation updates and such are created & updated via Obsidian along with exporting .md files as PDFs.

> **Status (Week 1):** Early development. The repository is set up, but the app is not yet in a working state. Parts of this document describe what the app is *meant* to do; the status column and the "Known issues" section say what actually works today. I will update both as features are built.

## 1. Overview

ArtFolio is a Flutter app for showing artwork online. Visitors browse images in a Pinterest-style grid, open a piece to see its details, and read a biography of the artist. It is meant for artists who want a simple portfolio and for people who want to browse art.

## 2. Setup and installation

1. **Versions used to build the app:**
   - Flutter: Flutter 3.44.5
   - Dart: Dart 3.12.2
1. **Get the code:**
   ```bash
   git clone https://github.com/<FrenchBrot>/ArtFolio.git
   cd ArtFolio
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Configuration:** The app needs no API keys or backend URL as of yet.

## 3. How to run it

```bash
flutter run -d chrome
```

To run on a phone or emulator instead, list the available targets with `flutter devices` and use `flutter run -d <device-id>`.

**What you should see when it works:** the gallery screen with artwork images laid out in a grid. (The grid alignment is not final yet.)

## 4. Features and usage

| Feature | What it does | Status |
| --- | --- | --- |
| Image grid (gallery) | Shows artwork images in a Pinterest-style grid | In progress: layout is uneven and misaligned |
| Clickable icons | Lets the user move between screens and act on artwork | In progress: some icons are still missing |
| Artwork details | Shows information about a single piece | Not started |
| Artist biography | Shows information about the artist | Not started |

**Intended primary flow** (this will be filled in screen by screen as each one is built):

1. Open the app to see the gallery grid of artwork.
2. Tap an artwork to open its details.
3. From the details, open the artist's biography.
4. Use the icons to go back or move between screens.

## 5. Project structure

- No official uploaded structure yet.
## 6. Screenshots

No screenshots yet, because the app does not display as intended. I will add at least one per screen once each one works.

| Screen | Screenshot |
| --- | --- |
| Gallery grid | Pending |
| Artwork details | Pending |
| Artist biography | Pending |

## 7. Known issues and next steps

**Known issues**

- The grid display is uneven and does not match the layout I want.
- Some clickable icons are missing.
- There were minor errors connecting the files in the starting template that still need to be fixed.
- The starting template has not been uploaded to this repository yet, and the setup steps above have not been tested from a fresh clone.

**Next steps**

1. Fix the errors and upload the working start file.
2. Build the Pinterest-like image grid.
3. Get all clickable icons working.
4. Add artwork details.
5. Add the artist biography.
6. Add screenshots, fill in the version numbers and project structure, and test the setup steps from a fresh clone.
