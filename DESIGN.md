---
name: Wedding Planner — Soft Botanical
description: >
  Warm, calm, organized mobile UI for a wedding and event planning app.
  Sage-beige canvas, four meaning-based category colors (slate, teal,
  terracotta, amber), folder-tab section headers, wavy sheet edges, and
  rounded type. Should feel like a well-kept planner, not a SaaS dashboard.
version: 0.1
provenance: >
  Derived from reference screenshots (EventPath-style wedding planner UI).
  Hex values are eyedropper-style approximations and fonts are inferred.
  Verify against the source design file if one exists.
colors:
  canvas: "#DEDBCC"
  sheet: "#F0EEE5"
  surface: "#E1DED2"
  surface-strong: "#D5D2C5"
  line: "#CFCCBD"
  ink: "#2E3943"
  ink-muted: "#55606B"
  ink-faint: "#8A929A"
  on-dark: "#FFFFFF"
  slate: "#44525F"
  slate-deep: "#38454F"
  teal: "#5C8173"
  teal-strong: "#4A6E61"
  teal-tint: "#C5D7CF"
  terracotta: "#D9795B"
  terracotta-ink: "#A94E32"
  terracotta-tint: "#F0D3C8"
  amber: "#E3A64B"
  danger: "#A83A2E"
typography:
  family: "Nunito, 'Nunito Sans', system-ui, sans-serif"
  display:   { size: 24, line: 30, weight: 300 }
  title-lg:  { size: 20, line: 26, weight: 600 }
  title-md:  { size: 17, line: 22, weight: 600 }
  body:      { size: 14, line: 20, weight: 400 }
  body-strong: { size: 14, line: 20, weight: 700 }
  label:     { size: 13, line: 18, weight: 600 }
  caption:   { size: 11, line: 15, weight: 500 }
  micro:     { size: 10, line: 14, weight: 500 }
spacing: { 1: 4, 2: 8, 3: 12, 4: 16, 5: 20, 6: 24, 8: 32 }
rounded: { sm: 10, md: 14, lg: 20, xl: 28, full: 999 }
elevation:
  flat: "none"
  raised: "0 1px 2px rgba(46,57,67,.08)"
  floating: "0 6px 16px rgba(46,57,67,.18)"
motion:
  duration: { fast: 120, base: 220, slow: 360 }
  easing:
    out: "cubic-bezier(0.22, 1, 0.36, 1)"
    in-out: "cubic-bezier(0.65, 0, 0.35, 1)"
---

# Design System: Soft Botanical

## 1. Overview and intent

The product helps couples, planners, and vendors coordinate one of the most emotional days of their lives. Every screen is dense with practical information (timelines, addresses, crew, notes), so the design has two jobs: **make dense information feel calm**, and **make an operational tool feel like it belongs to a wedding.**

The look comes from three ideas. Keep them, and keep everything else quiet.

1. **Paper and plants.** The canvas is a warm sage-beige, never white and never grey. Content sits on lighter "sheets", like cards laid on a table. A faint botanical pattern may sit on the canvas behind headers.
2. **Folder tabs.** Sections are colored tabs attached to their content, like dividers in a planner. Color tells you what *kind* of information it is.
3. **A soft wave.** Sheets that slide over the canvas have a gently wavy top edge. This is the one signature shape. Use it on sheets and the onboarding panel only.

Design relationships, not a pile of components. A screen should have one clear focal point, one primary action, and a visible hierarchy between tab, sheet, card, and text.

## 2. Color

### 2.1 Surfaces (the layering model)

Depth comes from **tone, not shadow**. Lighter means closer to the person.

| Token | Hex | Use |
|---|---|---|
| `canvas` | `#DEDBCC` | App background behind everything |
| `sheet` | `#F0EEE5` | Main content sheet that slides over canvas (Events List, Timeline) |
| `surface` | `#E1DED2` | Cards and rows sitting on a sheet |
| `surface-strong` | `#D5D2C5` | Inset areas: search field, expanded card body, pressed state |
| `line` | `#CFCCBD` | Dashed or solid dividers |

Rule: never put `sheet` directly on `sheet`. Step down to `surface`, then `surface-strong`.

### 2.2 Category colors (meaning, not decoration)

Four saturated colors carry meaning. Assign by what the content *is*, then reuse the same color everywhere it appears (tab, timeline card, dot, chip).

| Color | Token | Meaning | Examples from the product |
|---|---|---|---|
| Slate | `slate` `#44525F` | Structure and reference info | Package, Event Details, "Master" timeline track, selected dates, unread message row |
| Teal | `teal` `#5C8173` | Places, logistics, positive action | Locations, "Entertainment" track, primary buttons, the day's event date |
| Terracotta | `terracotta` `#D9795B` | People and emotion, plus things needing attention | Couple, "Video" track, dates on event cards, unread badge |
| Amber | `amber` `#E3A64B` | Extended people and warmth | Family |

When a new category appears, pick the closest meaning from this table. Do not invent a fifth hue. If a category truly has no match, use `slate`.

### 2.3 Text and tints

| Token | Hex | Use |
|---|---|---|
| `ink` | `#2E3943` | Primary text |
| `ink-muted` | `#55606B` | Secondary text, captions, roles |
| `ink-faint` | `#8A929A` | Placeholders and disabled only. Never for information that matters |
| `teal-strong` | `#4A6E61` | Teal for text, links, and buttons with small white text |
| `terracotta-ink` | `#A94E32` | Terracotta for small text on light surfaces (event dates) |
| `teal-tint` | `#C5D7CF` | Light fill for the active row under a teal tab |
| `terracotta-tint` | `#F0D3C8` | Light fill for warnings and highlights |
| `danger` | `#A83A2E` | Errors only. Not in the reference; always pair with an icon and message |

### 2.4 Color rules

- No gradients. No pure `#000`, no pure `#FFF` as a page background. White is only for text on colored fills.
- Do not use terracotta for everything. It is a signal; if three things on one screen are terracotta, two of them are wrong.
- Never rely on color alone. Every colored category also has an icon and a label.
- The user's own wedding palette (the two dots under "Wedding Colors") is content, not UI. Show it in small circles and never let it leak into the interface theme.

## 3. Typography

One rounded family, **Nunito** (variable, 200–900), carries everything. Its rounded terminals match the soft shapes and avoid the stiff look of system sans. If you want a more geometric headline, **Quicksand** at weight 500–600 is an acceptable substitute for `display` and `title-*` only.

| Role | Size / line | Weight | Used for |
|---|---|---|---|
| `display` | 24 / 30 | 300 (light) | Page identity in the app bar: "Kristina & Steven" |
| `title-lg` | 20 / 26 | 600 | Sheet titles: "Events List", "Timeline" |
| `title-md` | 17 / 22 | 600 | Tab header text: "Locations", "Event Details" |
| `body` | 14 / 20 | 400 | Notes, addresses, descriptions |
| `body-strong` | 14 / 20 | 700 | Names, key values (Room Number: **239**) |
| `label` | 13 / 18 | 600 | Card titles, buttons, chips |
| `caption` | 11 / 15 | 500 | Dates, durations, timestamps, message previews |
| `micro` | 10 / 14 | 500 | Role tags (Producer, Videographer), tab bar labels |

Rules:

- **Sentence case everywhere.** No ALL CAPS labels, no letter-spaced eyebrows above headings.
- The light `display` weight is part of the identity. Do not bold the couple's names.
- Line length: keep paragraphs under about 60 characters on mobile. Notes wrap naturally in a 16px gutter.
- Names carry an ampersand: "Kristina & Steven". Use the real ampersand character.
- Exactly one decorative type moment is allowed: the onboarding headline may underline a single key word in `terracotta`. Do not repeat that device on other screens.

## 4. Layout and spacing

Base unit **4px**. Allowed steps: 4, 8, 12, 16, 20, 24, 32. No magic numbers.

- Screen gutter: **16**. Content inside a sheet is inset **16** from the sheet edge.
- Card padding: **12–14**. Gap between stacked cards: **8**. Gap between sections: **16**.
- Tab header height: **48**. Bottom tab bar: **64** plus safe area.
- Tight relationships: icon to its label (8), name to its role caption (2–4), avatar overlap (−8).
- Loose relationships: between a tab and the previous section (16), between sheet title and first card (12).

Alignment: lists and notes are left-aligned. The app bar title and section tab headers are **centered**. Key/value rows are left-aligned with the value directly under or beside the label, never right-justified across a wide gap.

Structure of the app shell, top to bottom:

```
status bar
app bar        back • display title + date (centered) • calendar icon (terracotta)
(optional)     date strip or segmented tabs
sheet          wavy top edge, scrolls
bottom tabs    Overview • Timeline • Checklists • Chat • Gallery
```

## 5. Shape and depth

| Token | px | Use |
|---|---|---|
| `rounded.sm` | 10 | Search field, small chips, inner thumbnails |
| `rounded.md` | 14 | Cards, rows, timeline cards, image tiles |
| `rounded.lg` | 20 | Tab-and-panel groups, photo frames |
| `rounded.xl` | 28 | Sheet corners where no wave is used |
| `rounded.full` | 999 | Avatars, date chips, pills, buttons, FAB |

Use at least three of these on one screen. Everything at one radius is the generic "card kit" look this system avoids.

Depth: flat tonal layering by default (section 2.1). `raised` is allowed on small chips. `floating` is only for the floating add button (FAB). No shadow under every card.

### The wavy sheet edge

- A low-amplitude wave across the full width of the top edge of a sheet: amplitude about 8–12px, one gentle crest and one dip, never a zigzag.
- Build it as an SVG path or `clip-path`/mask so the fill, and the canvas behind, stay clean.
- Use on: the main content sheet on list and timeline screens, and the onboarding text panel. Not on cards, modals, or buttons.

### Botanical pattern

- Optional faint line-art floral tile on `canvas` only, at 6–8% opacity, behind headers and gaps.
- Never behind text-heavy content, and never on `sheet` or `surface`.

## 6. Iconography and imagery

- Outline icons, 1.5px stroke, round caps and joins, 20–24px. Phosphor (regular) or Lucide fit well.
- Icons are `ink` by default. Tint a row's icon with its category color only when it encodes meaning (the calendar icon in terracotta, location pin in teal).
- Never use emoji as UI icons.
- **Photos are the warmth.** Couple and family photos are shown large, with `rounded.lg`, framed inside a colored tab (terracotta for Couple, amber for Family). Avatars are circular photos with a 2px ring in the surface color behind them.
- Avatar sizes: 24 (stacks), 32 (list rows), 40 (chat), 56 (profile). Stacks overlap by 8px and end with a quiet `+N` in `caption` `ink-muted`.

## 7. Components

### 7.1 App bar
Back arrow left, centered `display` title with the date below it in `caption` `terracotta-ink`, calendar icon right in `terracotta`. Sits directly on `canvas`, no background or border.

### 7.2 Folder tab section (the signature component)
A header bar plus an attached panel, reading as one object.

- **Header bar:** height 48, full width, top corners `rounded.lg`, filled with the category color. Centered: icon + `title-md` in `on-dark`. Chevron at the right (rotates 180° when open). An optional action (like "+") sits at the left.
- **Panel:** attached directly below, fill `sheet`, bottom corners `rounded.lg`. Rows inside are separated by **dashed** `line` dividers.
- Collapsed sections show only the header bar, so an overview screen reads as a stack of colored tabs.
- Text on `amber` uses `ink`, not white (see Accessibility).
- Sub-rows (Bride Prep, Ceremony, Reception) are `teal-tint` strips with the title left and a small duration pill with a chevron button right.

### 7.3 Event card (accordion)
`surface` fill, `rounded.md`, padding 12.

- Collapsed: title in `label` (couple names), below it the date in `caption` `terracotta-ink` with a calendar icon, then location with a teal pin. Avatar stack right-aligned, chevron top right.
- Expanded: a `surface-strong` body appears under the title with an "Assigned Crew" list (avatar, name in `label`, role in `micro` `ink-muted`), then key/value rows (Ceremony, Reception, Story Package, Add-ons, Photographer, DJ), each with a small caption label above a `body-strong` value and a hairline divider.
- Only one level of nesting. Never accordion inside accordion.

### 7.4 Info row
Icon (20px) left, optional caption label, `body` or `body-strong` value. Dashed `line` between groups. Notes use this pattern: Room Number, Gate Code, Instructions.

### 7.5 Pills and chips
- **Duration pill:** `sheet` fill, full radius, `caption`, navigation icon + "30 Min".
- **Outline action chip:** 1px `ink-muted` border, full radius, icon + label ("Street View").
- **Date chip:** circle, `sheet` fill. The selected chip is larger and `sheet` with `ink`; the special day uses `teal` fill with white text; other marked days use `slate` fill.

### 7.6 Buttons
- **Primary:** full radius, height 44, `teal-strong` fill, white `label`, trailing arrow allowed when it implies moving forward ("Get started").
- **Secondary:** transparent, 1px `ink-muted` border, `ink` label.
- **Text link:** `teal-strong`, `label`, with a chevron ("Show All ⌄").
- **FAB:** 48px circle, `surface-strong` fill with `ink` plus icon, `floating` shadow. One per screen at most.
- Minimum touch target 44×44.

### 7.7 Search field
`surface-strong`, `rounded.sm`, height 40, search icon left, placeholder in `ink-faint` at `caption`.

### 7.8 Calendar
Month and year as two pills with small dropdown carets, left/right chevrons beside them. Weekday header in `caption` `ink-muted`. Days are circular chips, 36px. Days outside the month are dimmed. Selected date: `teal` fill. Dates with events: `slate` fill. The Events List and its count ("23 Events") sit below on a wavy sheet.

### 7.9 Timeline
**Vertical day view:** a time ruler on the left with tick marks and times in `caption`. A thick rounded rail marks the current day span. Event cards align to the ruler.

- Card: `rounded.md`, padding 12, title in `label`, avatar stack, then clock icon + time range in `caption`, a "⋮" overflow menu top right.
- Fill by track, using the category map: neutral `surface` (general), `slate` (master), `teal`, `terracotta`. White text on colored fills.
- A "now" marker: small dot on the ruler and a `slate` pill with the current time at the right edge.

**Horizontal overview:** a time scale across the top, then pill-shaped **track bars** (Master in `slate`, Entertainment in `teal`, Video in `terracotta`), each followed by dot-and-label events colored by their track.

### 7.10 Messages
Segmented control: two tabs ("Messages", "Contacts"), the active one on `teal` with icon, inactive on `sheet`. Rows: avatar 40, name `label`, timestamp `caption` right-aligned, two-line preview in `caption` `ink-muted`. **Unread rows** flip to a `slate` fill with light text, and carry a small `terracotta` count badge next to the name.

### 7.11 Bottom tab bar
Five items: Overview, Timeline, Checklists, Chat, Gallery. Icon 22px, label in `micro`. Inactive: `ink-muted`. Active: `ink`, bolder label. Bar fill `canvas` with a hairline `line` top edge. Respect the safe-area inset.

### 7.12 Onboarding
Full-bleed couple photo on the top 55–60%. A `sheet` panel overlaps it from below with the wavy top edge. Headline in `title-lg` centered, supporting copy in `body` `ink-muted`, primary teal pill below. Footer: "Next" left, dash-style pager center (active dash longer and `teal`), "Skip" right.

## 8. Motion

> The reference screenshots are static, so everything in this section is **recommended behavior** consistent with the soft look, not something extracted from the design.

Motion answers a person's action. It does not decorate.

| Interaction | Behavior | Timing |
|---|---|---|
| Expand / collapse accordion or folder tab | Panel height animates, chevron rotates 180°, content fades in 60ms after height starts | `base` 220, `out` |
| Segmented tab or calendar month change | Indicator slides; content cross-fades | `base` 220, `in-out` |
| Press on card, chip, button | Scale to 0.98, fill steps to the next darker surface | `fast` 120 |
| Sheet or modal appears | Slides up from the bottom edge | `slow` 360, `out` |
| New timeline item or drag-drop | Item slides into place; neighbors reflow | `base` 220, `out` |
| Onboarding first view | The wavy panel rises once | `slow` 360, `out` |

Rules:

- **No** scroll-triggered fade-ins on every section. No hover effects on every card. No looping animation.
- One orchestrated moment is allowed: the onboarding panel rise. Everything else is a direct response to a tap.
- Respect `prefers-reduced-motion` (and the platform equivalent): replace transforms with an instant change or a 120ms opacity fade.
- Animate `transform` and `opacity`, not layout properties, except for the accordion height.

## 9. Accessibility

Contrast, approximate. Treat these as the minimum and re-measure after final color tuning.

| Pairing | Ratio | Verdict |
|---|---|---|
| `on-dark` on `slate` | about 8.0 | Pass at any size |
| `on-dark` on `teal-strong` | about 5.3 | Pass. Use for buttons and small text |
| `on-dark` on `teal` | about 4.3 | Large or bold (18px+) only |
| `on-dark` on `terracotta` | about 3.1 | Large or bold (16px+ semibold) only. Deepen to `#C0603F` if you need small white text |
| `ink` on `amber` | about 5.5 | Pass. **Use `ink` on amber, not white (white is about 2.1)** |
| `ink-muted` on `canvas` | about 4.6 | Pass |
| `terracotta-ink` on `sheet` | about 4.6 | Pass for small date text. Plain `terracotta` on `sheet` is about 2.6 and fails |

Also:

- Visible keyboard and switch focus: 2px `teal-strong` ring with 2px offset, on every interactive element, never removed.
- Every category color is paired with an icon and text label.
- Touch targets at least 44×44, even when the visible element is smaller (avatars, chevrons, the "⋮" menu).
- `micro` text (10px) is only for labels paired with an icon. Allow dynamic type scaling to at least 200% without clipping.
- Chevrons, FAB, and icon-only buttons need accessible names. Accordions expose expanded/collapsed state.
- Text placed over photos needs a `sheet` panel behind it, not a gradient overlay.

## 10. Responsive behavior

Designed mobile-first for 360–430px wide.

- Under 480: single column, bottom tab bar, sheet fills the width.
- 480–767: center the content at a max width of 480, `canvas` fills the sides.
- 768 and up: two panes (Events List on the left, selected event on the right, max 720 for the detail pane), and the bottom tab bar becomes a left rail with the same five items.
- Preserve hierarchy as the screen narrows: simplify spacing and drop secondary metadata (for example, the avatar stack collapses to `+N`) before shrinking text below the type scale.

## 11. Content and voice

Calm, reassuring, plain. The reader may be stressed and in a hurry, on the day itself.

- Sentence case. Short verbs. No exclamation marks except in the onboarding headline.
- Name things by what the user knows: "Bride Prep", "Venue Images", "Travel Plan", not internal system terms.
- Keep a verb consistent across the flow: a button that says "Save changes" produces a message that says "Changes saved".
- Times and dates follow the user's locale. Use a single format across the app (for example "12 Jul 2025" and 24-hour time for Indonesia), never mixed.
- Roles under names are quiet captions: "Paige Johnson · Videographer" is two lines, not a badge.
- Empty states say what to do next ("No events yet. Add your first event."). Errors say what happened and how to fix it, with no apology.

## 12. Do and don't

**Do**
- Layer with tone: canvas, sheet, surface, surface-strong.
- Let color tabs and the wavy sheet be the memorable elements. Keep everything else quiet.
- Reuse category colors for the same kind of content across screens.
- Vary radii by role (pill, card, group).
- Use real content: names, times, addresses, photos.

**Don't**
- White cards on a grey page, drop shadows on everything, gradients, glassmorphism.
- ALL CAPS labels, letter-spaced eyebrows, or accenting a random word in a headline.
- A new accent color per feature.
- Waves, tabs, or botanical patterns repeated until they become wallpaper.
- Identical rounded cards stacked with no hierarchy.
- Scroll-triggered entrance animation on every section.

## 13. Instructions for AI agents

This app already works. The job is a **visual and interaction restyle**, not a rebuild.

1. **Do not change** information architecture, routes, data models, or behavior unless asked. Restyle what exists.
2. **Tokens first.** Define colors, type, spacing, radius, elevation, and motion as variables (CSS custom properties, a Tailwind theme, or the platform's theme object) from the frontmatter above. Replace hard-coded values with tokens.
3. **Migration order:** tokens, then canvas and sheet shell, then app bar and bottom tabs, then lists and cards, then detail screens (folder tabs, info rows), then timeline, then chat, then calendar, then onboarding.
4. **Map existing screens to patterns:** a list of events becomes event cards (7.3); a detail page with many fields becomes folder tabs with info rows (7.2, 7.4); schedules use the timeline (7.9); messages use 7.10.
5. **Ask before inventing.** If a screen has no matching pattern, compose from existing tokens and say so. Do not add new colors, fonts, or radii.
6. **Check before done:**
   - Only tokens are used, with no magic numbers.
   - At least three radii and two surface tones on screen.
   - Color is always paired with icon and label; contrast table in section 9 holds.
   - Focus rings visible; touch targets 44px; reduced motion respected.
   - No gradients, no ALL CAPS labels, no scroll-triggered fade-ins.
   - The wavy edge appears at most once per screen.

### Token starter (CSS)

```css
:root {
  --canvas: #DEDBCC;  --sheet: #F0EEE5;  --surface: #E1DED2;  --surface-strong: #D5D2C5;
  --line: #CFCCBD;    --ink: #2E3943;    --ink-muted: #55606B;
  --slate: #44525F;   --teal: #5C8173;   --teal-strong: #4A6E61;  --teal-tint: #C5D7CF;
  --terracotta: #D9795B; --terracotta-ink: #A94E32; --amber: #E3A64B;
  --radius-sm: 10px; --radius-md: 14px; --radius-lg: 20px; --radius-xl: 28px;
  --ease-out: cubic-bezier(0.22, 1, 0.36, 1);
  --dur-fast: 120ms; --dur-base: 220ms; --dur-slow: 360ms;
  font-family: Nunito, 'Nunito Sans', system-ui, sans-serif;
}
@media (prefers-reduced-motion: reduce) {
  :root { --dur-base: 1ms; --dur-slow: 1ms; }
}
```
