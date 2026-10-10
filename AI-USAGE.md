# AI Usage: ArtFolio

**Assistant used:** Claude (Anthropic), in the claude.ai chat, inside a Project called "ArtFolio Flutter App". 

---

## 1. How I used AI

### Entry 1: Theme and spacing from my design system

- **Date / tool:** September 28, 2026, Claude
- **Asked for:** Turn my design-system worksheet (palette, type scale, spacing) into Flutter theme code. Fix my primary color, because `#7C3AED` failed the contrast check against `#1F1F29` text. Match Pinterest's mobile text sizes and spacing.
- **Got back:** `lib/theme/app_theme.dart` (colors, `ColorScheme`, `TextTheme`, button/input/chip themes) and `lib/theme/app_spacing.dart`. It also gave contrast figures: the old pairing was about 2.9:1, and the new primary `#A78BFA` with the same dark text is about 6.0:1.
- **Kept / changed / why:** Kept my violet palette and Pinterest direction from my prelim. Moved primary to `#A78BFA` with dark text, and kept `#7C3AED` as secondary with white text. 
- **Commit:** b8aaef4f29cc8780d6772db1729be8de31d08da7

### Entry 2: Supabase backend, config files and walkthrough

- **Date / tool:** October 4 , Claude
- **Asked for:** Exact steps to connect ArtFolio to Supabase, given the public GitHub repo, plus `.env`, `.gitignore`, `main.dart` and `pubspec.yaml`.
- **Got back:** An 8-step walkthrough, SQL for the `categories`, `artworks` and `artist_profile` tables, Row Level Security policies, storage-bucket policies, and the config files.
- **What I did myself:** Created the Supabase project, ran the SQL, created the `artwork-images` bucket, created the admin user, and pasted my own URL and key into my local `.env`. 
- **Kept / changed / why:** Kept the schema as given. The key naming and package version were later corrected (see Section 2, item 2).
- **Commit:** 46c8cc8de2bc81b26fb866f4fbad781a93bbb602

### Entry 3: Home, Search, Profile screens and the tab shell

- **Date / tool:** October 5 , Claude
- **Asked for:** The three screens and a bottom-nav shell, compatible with my widgets and my Supabase tables.
- **Got back:** `home.dart`, `search.dart`, `profile.dart`, `app_shell.dart`, `models/pin.dart`, `models/category.dart`, the two repository files and `constants/artist.dart`.
- **Kept / changed / why:** kept the screens as is.
- **Commit:** 7dac84606b3e218f589043b001dc04e87627fae2

### Entry 4: Artwork detail screen

- **Date / tool:** October 5 , Claude
- **Asked for:** Tapping a thumbnail should open the full photo with its title, description and category.
- **Got back:** `artwork_detail.dart`, `Pin` extended with `description` and `categoryName`, a query that fetches the category name with `categories(name)`, and a Hero transition from the thumbnail.
- **Kept / changed / why:** Kept it as given and tested it with my own artwork. 
- **Commit:** 7dac84606b3e218f589043b001dc04e87627fae2

### Entry 5: Debugging with my console output

- **Date / tool:** October 4 , Claude
- **Asked for:** Why photos weren't loading, then why a Windows build crashed.
- **Got back:** For the first, it identified `PGRST125 Invalid path specified in request URL` as a malformed `SUPABASE_URL` (a stray `/rest/v1` or trailing slash). For the second, it explained that Windows Smart App Control was blocking Flutter's own `impellerc.exe`, not any project code.
- **Kept / changed / why:** I fixed the value in my `.env` myself. 
- **Commit:** 46c8cc8de2bc81b26fb866f4fbad781a93bbb602

### Entry 7: Profile content and contact links

- **Date / tool:** October 9 , Claude
- **Asked for:** Show my bio and make the Instagram, Ko-fi, Cara and email icons open the app or the browser.
- **Got back:** Updated link-opening code in `profile.dart` that accepts full URLs, `mailto:` links or bare emails, plus the SQL to store the bio and links.
- **Kept / changed / why:** I wrote the bio and chose to use general platform URLs for now.
- **Commit:** ddc9958e4b430663a472998edbeb27d9802a0186

---

## 2. Where the AI got it wrong

Keep at least three you can speak to. Delete any you can't honestly claim.

### 2.1 A file it depended on never existed

- **What it gave me:** `pin_masonry_grid.dart`, described as error-free, which imports `pin_card.dart`. That file only existed as an example snippet inside my design doc, never as a real file, so the project wouldn't compile.
- **What was wrong:** A missing file means a compile error. The doc's example also used `Image.network` with no width, which collapses tiles until the image loads.
- **What I did instead:** The AI noticed while building the home screen and created `lib/widgets/pin_card.dart` using `CachedNetworkImage` with `width: double.infinity`.
- **Commit:** b8aaef4f29cc8780d6772db1729be8de31d08da7

### 2.2 Out-of-date Supabase key names and package version

- **What it gave me:** `SUPABASE_ANON_KEY`, `Supabase.initialize(anonKey: ...)` and `supabase_flutter: ^2.8.0`.
- **What was wrong:** Supabase is replacing anon/service-role keys with publishable/secret keys by the end of 2026, and the `publishableKey:` parameter doesn't exist in the older package version.
- **What I did instead:** When I asked for setup steps, the AI searched current docs and flagged its own earlier files as outdated. I asked which places needed changing. Renamed to `SUPABASE_PUBLISHABLE_KEY` / `publishableKey:` in `.env`, `.env.example` and `main.dart`, and bumped the package to `^2.12.0`.
- **Commit:** 1bfab5b65f492791e0f93b31c060103535937ed2

### 2.3 UI for features my database can't back

- **What it gave me:** `Pin.creatorName`, a 5-tab bottom bar (Create, Notifications), and `BoardCard`, all from a Pinterest-clone component list.
- **What was wrong:** ArtFolio has one artist, no boards table, no notifications and no in-app uploads. There's no creator column to read.
- **What I did instead:** Used a constant (`artistDisplayName = 'Dean'`), made Create/Notifications show a snackbar explaining they're not part of the app, and left `BoardCard` unused. 
- **Commit:** 1bfab5b65f492791e0f93b31c060103535937ed2

### 2.4 First diagnosis of "photos not loading" was off-target

- **What it gave me:** A checklist about bucket visibility and `image_url` formatting.
- **What was wrong:** My console log showed `PGRST125` on every query, so the problem was my `SUPABASE_URL`, not the images.
- **What I did instead:** Pasted the console output, got the real cause, and fixed `.env`. Lesson: read the console first.
- **Commit:** 1e787fbda12a5c17272427e4a23adbcd1fa6dbd5

---

## 3. Who wrote what

### Parts I wrote myself

Note: commit links are all the same since i committed multiple files every time and this was the final clean commit of all these widgets.

| File                                     | Commit                                   | What it does and why it's built that way                                                                                                                                                                                                            |
| ---------------------------------------- | ---------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `lib/main.dart`                          | ddc9958e4b430663a472998edbeb27d9802a0186 | Loads `.env`, checks the Supabase URL and key exist (throws a clear error if not), calls `Supabase.initialize`, keeps one shared `supabase` client, wraps the app in `DevicePreview` (off in release builds) and starts `AppShell` with `appTheme`. |
| `lib/widgets/pin_card.dart`              | ddc9958e4b430663a472998edbeb27d9802a0186 | One grid tile: a cached image inside a `Hero` (tag is the image URL, so no extra id parameter is needed), a bookmark button, a title and the creator name. It takes data and callbacks only.                                                        |
| `lib/widgets/pin_masonry_grid.dart`      | ddc9958e4b430663a472998edbeb27d9802a0186 | A 2-column staggered grid of `PinCard`s with 8px gutters and 16px edge padding. Cards size themselves from their images, which creates the staggered look. `shrinkWrap`/`physics` options let Profile nest it inside another scroll view.           |
| `lib/widgets/primary_button.dart`        | ddc9958e4b430663a472998edbeb27d9802a0186 | A `FilledButton` (with an optional icon). Colors and shape come from the theme, so no styling is repeated here.                                                                                                                                     |
| `lib/widgets/secondary_button.dart`      | ddc9958e4b430663a472998edbeb27d9802a0186 | An `OutlinedButton` styled by the theme, for lower-priority actions.                                                                                                                                                                                |
| `lib/widgets/circular_icon_button.dart`  | ddc9958e4b430663a472998edbeb27d9802a0186 | A round tappable icon of a given size, used for the contact icons on Profile.                                                                                                                                                                       |
| `lib/widgets/profile_avatar.dart`        | ddc9958e4b430663a472998edbeb27d9802a0186 | A circular cached image of a given radius. A person icon shows while loading, on error, or if the URL is empty.                                                                                                                                     |
| `lib/widgets/board_card.dart`            | ddc9958e4b430663a472998edbeb27d9802a0186 | A card with a square cover image, title and pin count. Currently unused, because my database has no boards table.                                                                                                                                   |
| `lib/widgets/section_header.dart`        | ddc9958e4b430663a472998edbeb27d9802a0186 | A bold title with an optional action link on the right, in the secondary color.                                                                                                                                                                     |
| `lib/widgets/tag_chip.dart`              | ddc9958e4b430663a472998edbeb27d9802a0186 | A `ChoiceChip` wrapper for category filters and the category label on the detail screen. The look comes from the chip theme.                                                                                                                        |
| `lib/widgets/top_navigation.dart`        | ddc9958e4b430663a472998edbeb27d9802a0186 | An `AppBar` containing a tappable search pill and the profile avatar. It implements `PreferredSizeWidget` so it can be passed to `Scaffold.appBar`.                                                                                                 |
| `lib/widgets/bottom_navigation_bar.dart` | ddc9958e4b430663a472998edbeb27d9802a0186 | A fixed 5-item `BottomNavigationBar` (Home, Search, Create, Notifications, Profile) driven by `currentIndex` and `onTap`.                                                                                                                           |
| `lib/widgets/input_field.dart`           | ddc9958e4b430663a472998edbeb27d9802a0186 | A `TextField` with a label, controller, optional obscured text and error text, styled by the input theme. No screen uses it yet.                                                                                                                    |
| `lib/widgets/dropdown_menu.dart`         | ddc9958e4b430663a472998edbeb27d9802a0186 | A `PopupMenuButton` that shows a list of options and reports the chosen one through `onSelected`. No screen uses it yet.                                                                                                                            |
| `lib/widgets/empty_state.dart`           | ddc9958e4b430663a472998edbeb27d9802a0186 | A centered icon and message with an optional button (a `PrimaryButton`), used for empty results and load errors.                                                                                                                                    |
| `lib/widgets/loading_skeleton.dart`      | ddc9958e4b430663a472998edbeb27d9802a0186 | A placeholder block that pulses between 50% and 100% opacity over 900ms. It's the one stateful widget, because the animation controller needs a ticker. It owns no app data.                                                                        |
### The AI-written code I understand best

**`lib/data/artworks_repository.dart`, `fetchArtworks`:** It builds one Supabase query on the `artworks` table and adds filters only when they're needed. `.eq('tag_id', categoryId)` runs when a category chip is selected, `.ilike('title', '%query%')` does case-insensitive partial matching for search, and `.order('created_at', ascending: false)` puts newest work first. The `categories(name)` part of the `select` asks Supabase to follow the foreign key from `artworks.tag_id` to `categories.id` and nest the category name in each row, so the detail screen doesn't need a second request. Each row becomes a `Pin`. Home, Search and Profile all call this one function, so a schema change gets fixed in one place. 