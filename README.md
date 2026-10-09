# ArtFolio

[![Made with AI](https://img.shields.io/badge/Made_with-AI_assistance-blue)](https://claude.ai/chat/AI-USAGE.md)

> **AI credit:** Claude
> See [AI-USAGE.md](https://claude.ai/chat/AI-USAGE.md) for the full account.

> **Status (Finals):** All four MVP features from my proposal are built and working against a live Supabase backend. A few things are intentionally unfinished; they are listed under [Known issues and next steps](https://claude.ai/chat/80fe1697-630e-48fb-a591-5a73d54163c6?onboarding=1#7-known-issues-and-next-steps).

## 1. Overview

ArtFolio is a personal portfolio app for a freelance illustrator. Visitors browse the artist's work in a Pinterest-style masonry grid, filter it by category, search by title, open any piece for a full-size view with its description, and read the artist's bio and contact links (Instagram, Ko-fi, Cara, email). It is built for one artist showing professional work to potential clients, in place of scattered social-media profiles.

## 2. Setup and installation

1. **Versions used to build the app**
    
    - Flutter 3.44.5
    - Dart 3.12.2 (the project requires Dart `^3.6.0`, see `pubspec.yaml`)
2. **Get the code**
    
    ```bash
    git clone https://github.com/<FrenchBrot>/ArtFolio.git
    cd ArtFolio
    ```
    
3. **Install dependencies**
    
    ```bash
    flutter pub get
    ```
    
4. **Configure the backend.** ArtFolio reads its artwork, categories and artist profile from a [Supabase](https://supabase.com/) project. Copy the example environment file and fill in your own project's values:
    
    ```bash
    cp .env.example .env
    ```
    
    ```dotenv
    SUPABASE_URL=https://<your-project-ref>.supabase.co
    SUPABASE_PUBLISHABLE_KEY=<your-publishable-key>
    ```
    
    - Use only the **publishable** (public) key. Never put a secret / service-role key in this file.
    - `.env` is git-ignored, so real values are never committed. It is listed under `assets:` in `pubspec.yaml` so the app can load it at startup; the app stops with a clear error message if either value is missing.
5. **Create the Supabase tables** (SQL editor or Table Editor). The app expects:
    
    |Table|Columns|
    |---|---|
    |`categories`|`id` (uuid, pk), `name` (text)|
    |`artworks`|`id` (uuid, pk), `title` (text), `description` (text, nullable), `image_url` (text), `tag_id` (uuid, fk → `categories.id`), `created_at` (timestamptz, default `now()`)|
    |`artist_profile`|one row: `bio` (text), `profile_image_url` (text), `contact_links` (jsonb, keys `instagram`, `kofi`, `cara`, `email`)|
    
    Upload artwork images to a public Storage bucket (`artwork-images`) and paste each image's public URL into `artworks.image_url`. Row Level Security should allow **read-only** access for the public/anon role; only the signed-in admin (you, via the Supabase dashboard) can insert, update or delete.
    

## 3. How to run it

```bash
flutter run -d chrome
```

To run on a phone or emulator instead, list targets with `flutter devices`, then `flutter run -d <device-id>`.

**What you should see when it works:** the Home screen with a search pill and avatar at the top, a row of category chips ("All", then each category), and a two-column staggered grid of your artwork underneath. While data loads you see grey skeleton tiles. In debug mode the app is wrapped in `device_preview`, so on the web you also get a device frame and a side panel for switching phone sizes (this switches off automatically in release builds).

## 4. Features and usage

The app has a bottom navigation bar with five tabs. **Home**, **Search** and **Profile** are real screens. **Create** and **Notifications** are part of the design system's nav bar, but ArtFolio is a single-artist portfolio (artwork is added in the Supabase dashboard), so tapping either shows a short explanatory message instead of a screen.

|Feature|What it does|Status|
|---|---|---|
|Masonry home grid|Staggered two-column grid of all artworks, newest first; pull down to refresh|Working|
|Artwork categories|Horizontal chip row filters the grid by category (or "All"); chips come from the `categories` table|Working|
|Artwork detail|Full-size image (animated with a `Hero` transition from the tapped tile), title, category chip, description|Working|
|Search|Live title search (debounced) combined with the category chips|Working|
|Artist profile & contact|Avatar, name, bio, contact buttons that open Instagram / Ko-fi / Cara / email, plus a grid of all work|Working|
|Loading / empty / error states|Skeleton tiles while loading; friendly messages with a Retry button if the network fails or no artwork exists|Working|
|Edit Profile button|Placeholder on the Profile screen|Not wired up|
|Bookmark button on tiles|Visible on each tile, but does not save anything yet|Not wired up|

**Primary flow, screen by screen**

1. **Home.** Open the app to see the gallery grid. Tap a category chip (for example _Sketches_) to filter; tap _All_ to clear the filter. Pull down to reload.
2. **Artwork detail.** Tap any tile. The image expands into the detail page with its title, category and description. Use the back arrow to return to the same scroll position.
3. **Search.** Tap the search pill on Home (or the _Search_ tab). Type part of a title; results update about 350 ms after you stop typing. Combine with a category chip to narrow further. Tap the ✕ in the field to clear it.
4. **Profile.** Tap the avatar on Home (or the _Profile_ tab) to read the bio, tap a contact icon to open that link in the matching app or the browser, and scroll down through "Your work". Tapping a piece there opens the same detail page.

## 5. Project structure

```
lib/
├── main.dart                 # loads .env, initialises Supabase, wraps app in DevicePreview
├── constants/
│   └── artist.dart           # artistDisplayName shown under every artwork and on Profile
├── data/
│   ├── artworks_repository.dart    # fetchArtworks(categoryId, searchQuery) – shared by Home, Search, Profile
│   └── categories_repository.dart  # fetchCategories()
├── models/
│   ├── pin.dart              # one artwork (image, title, description, category name)
│   └── category.dart         # one category row
├── screens/
│   ├── app_shell.dart        # bottom nav + IndexedStack that keeps each tab's state alive
│   ├── home.dart             # category chips + masonry grid
│   ├── search.dart           # debounced search + chips + grid
│   ├── artwork_detail.dart   # single artwork view
│   └── profile.dart          # bio, contact links, all artwork
├── theme/
│   ├── app_theme.dart        # colours (AppColors), text styles, light ThemeData
│   └── app_spacing.dart      # 4 / 8 / 16 / 24 px spacing scale
└── widgets/                  # the 15 reusable components from design system v2
    ├── pin_card.dart, pin_masonry_grid.dart, tag_chip.dart
    ├── top_navigation.dart, bottom_navigation_bar.dart
    ├── primary_button.dart, secondary_button.dart, circular_icon_button.dart
    ├── input_field.dart, dropdown_menu.dart, section_header.dart
    ├── profile_avatar.dart, board_card.dart
    └── empty_state.dart, loading_skeleton.dart
assets/
├── images/                   # logo, artist placeholder
│   └── samples/              # bundled fallback artwork
└── icons/
```

**Where state lives.** Each screen (`HomeScreen`, `SearchScreen`, `ProfileScreen`) owns its own state with `setState` (selected category, search text, loading/error flags, fetched artworks). Widgets in `widgets/` are stateless: they take data and callbacks. `AppShell` holds only the selected tab index. Supabase is reached through one global client in `main.dart`, and only the two repository files talk to it for artwork and category data.

## 6. Screenshots

The design system used for every screen (palette, type scale, spacing and components) is in [`docs/design-system-v2-swatch-sheet.png`](https://claude.ai/chat/docs/design-system-v2-swatch-sheet.png).

<!-- FILL IN: run the app, take one screenshot per screen below, save them in docs/screenshots/ with these file names, then delete this comment. -->

| Screen                               | Screenshot              |
| ------------------------------------ | ----------------------- |
| Home (masonry grid + category chips) | <img width="440" height="923" alt="home" src="https://github.com/user-attachments/assets/398bddfe-474f-406a-80fe-71650b10d779" /> |
| Home filtered by a category          | <img width="440" height="923" alt="home" src="https://github.com/user-attachments/assets/042a4f27-12d0-4113-b1f5-b74ae8eb8cc7" /> |
| Artwork detail                       | <img width="443" height="920" alt="artwork_detail" src="https://github.com/user-attachments/assets/5e9ddaa8-c1a0-4d9e-a3ae-0c209b3d6bbe" /> |
| Search results                       | <img width="443" height="923" alt="search" src="https://github.com/user-attachments/assets/a3c26d48-a0b4-4fe0-9429-194834b11253" /> |
| Profile (bio + contact + work)       | <img width="442" height="927" alt="profile" src="https://github.com/user-attachments/assets/9acc1d0a-f5be-4cde-9f54-724948882cd1" /> |

## 7. Known issues and next steps

**Known issues**

- **Create and Notifications tabs have no screens.** They only show a snackbar. This is deliberate for a single-admin portfolio, but the tabs are still visible.
- **Edit Profile button does nothing** (there is a `TODO` in `profile.dart`).
- **The bookmark icon on each tile is not connected to anything**, so tapping it does not save a piece.
- **Contact icons use generic Material icons** (camera, coffee cup, palette, mail) instead of the real Instagram, Ko-fi and Cara logos.
- **The `.env` file is bundled as an app asset**, so on a web build the Supabase URL and publishable key are readable by anyone. That is acceptable for a public read-only key protected by Row Level Security, but a secret key must never go in it.
- **Artwork is managed only through the Supabase dashboard.** There is no in-app upload or admin login.

**Next steps**

1. Make the profile editable and move the artist name into `artist_profile`.
2. Stretch goals from my proposal: in-app artwork upload for the admin, a QR code for sharing the portfolio, and extra animated transitions beyond the current `Hero` animation.
3. Replace the generic contact icons with brand icons (for example with `font_awesome_flutter`).
