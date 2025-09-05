# Final Plan: "Next-Gen GST Reform" Interactive Page

## 1. Project Goal & Vision

To create a clean, fast, and highly functional single-page tool that allows users to instantly search, filter, and explore the latest GST rate changes. The page will carry a strong news-infographic identity while providing best-in-class interactive features for a seamless user experience on any device.

## 2. Page Structure & Components

### Hero Section:

**Title:** Next-Gen GST Reform

**Kicker/Subtitle:** Historic Diwali Gift • Better & Simpler

### Key Highlights Section:

**Purpose:** To provide an immediate, scannable overview of the most significant changes.

**Layout:**

**Summary Stat:** A bold, centered line of text: "Total Items Updated: 93 (75 Cheaper, 18 More Expensive)".

**Cards:** A 2x2 grid on desktop (stacking to a single column on mobile) showcasing the 4 most impactful changes (e.g., Health Insurance, Non-alcoholic beverages, etc.). Each card will visually stand out and contain the item name, emoji, and the rate change.

### Sticky Controls Bar:

**Functionality:** This bar will appear directly below the Key Highlights. As the user scrolls, it will stick to the top of the viewport, ensuring search and filter controls are always accessible.

**Components:**

**Search Bar:** A prominent search input field: [ 🔍 Search for an item... ].

**Filter Buttons:** Simple toggles: [ All ], [ Cheaper ↓ ], [ Expensive ↑ ].

**Category Dropdown:** A dropdown menu to filter by a specific category: [ Filter by Category ▼ ].

### Floating Category Navigator:

**Desktop:** A fixed sidebar on the left or right, listing all categories as clickable anchor links (e.g., 🚜 Agriculture, 🚗 Automotive). Clicking a link smoothly scrolls the user to the corresponding section.

**Mobile:** A discreet floating button (e.g., with a "Categories" or list icon ☰) fixed to the bottom-right corner. Tapping it opens a modal or a slide-up menu with the same list of category links, allowing users to jump to sections without extensive scrolling.

### Main Content - Accordion List:

**Structure:** The main body of the page, where each category from the JSON is rendered as a <details> accordion. This preserves the clean, collapsible structure from the original sample.

**Default State:** The first accordion (🏠 Daily Essentials or a similar high-interest category) will be open by default. All others will be closed.

**Item Display:** Each item will clearly show the change using text, colors, and arrows:

Item Name: Old Rate% → New Rate% <span class="drop">↓X pp</span> or <span class="hike">↑X pp</span>

### Footer:

**Content:** Minimalist footer with data source attribution: "Source: Government of India (CBIC)".

## Text Wireframes

### Desktop Wireframe (width > 800px)

```
+--------------------------------------------------------------------------------------+
|                                                                                      |
|                               Next-Gen GST Reform                                  |
|                      Historic Diwali Gift • Better & Simpler                         |
|                                                                                      |
|                Total Items Updated: 93 (75 Cheaper, 18 More Expensive)               |
|                                                                                      |
|      +-------------------------+      +-----------------------------------------+    |
|      | 🛡️ Health & Life Ins... |      | 🚗 Petrol/LPG/CNG Cars (≤1200cc)        |    |
|      |    18% → 0%  (↓18 pp)   |      |    28% → 18% (↓10 pp)                   |    |
|      +-------------------------+      +-----------------------------------------+    |
|      +-------------------------+      +-----------------------------------------+    |
|      | ☕ Non-alcoholic bev... |      | 🚜 Tractor Tyres & Parts                |    |
|      |    18% → 40% (↑22 pp)   |      |    18% → 5%  (↓13 pp)                   |    |
|      +-------------------------+      +-----------------------------------------+    |
|                                                                                      |
+======================================================================================+
| [ 🔍 Search for an item...               ]  [ All ] [ Cheaper ↓ ] [ Expensive ↑ ] [Category ▼] |  <- This bar becomes sticky
+======================================================================================+
|                                                                                      |
|  +----------------------+      +---------------------------------------------------+ |
|  | NAVIGATION           |      | ▼ 🏠 Daily Essentials (Accordion OPEN by default) | |
|  |                      |      |   ----------------------------------------------- | |
|  | 🚜 Agriculture       |      |   🧴 Hair Oil, Shampoo...  18% → 5%  (↓13 pp)     | |
|  | 👕 Apparel           |      |   🧈 Butter, Ghee, Cheese  12% → 5%  (↓7 pp)      | |
|  | 🚗 Automotive        |      |   ...                                             | |
|  | 🍔 Food & Bev        |      |                                                   | |
|  | ... (all cats)       |      | ► 💊 Healthcare Relief (Accordion CLOSED)         | |
|  |                      |      |                                                   | |
|  |                      |      | ► 🚜 Farmers & Agriculture (Accordion CLOSED)     | |
|  |                      |      |                                                   | |
|  +----------------------+      | ► ... (and so on for all other categories)        | |
|       ^ This sidebar is        +---------------------------------------------------+ |
|         always visible                                                             |
|                                                                                      |
|                                [ Source: Government of India (CBIC) ]                |
+--------------------------------------------------------------------------------------+
```

### Mobile Wireframe (width < 600px)

```
+------------------------------------------+
|                                          |
|            Next-Gen GST Reform           |
|      Historic Diwali Gift • Better...    |
|                                          |
|    Total Items: 93 (75 Cheaper...)       |
|                                          |
|    +----------------------------------+  |
|    | 🛡️ Health & Life Ins...          |  |
|    |    18% → 0%  (↓18 pp)            |  |
|    +----------------------------------+  |
|    +----------------------------------+  |
|    | 🚗 Petrol/LPG/CNG Cars...        |  |
|    |    28% → 18% (↓10 pp)            |  |
|    +----------------------------------+  |
|    ... (other highlight cards stack)     |
|                                          |
+==========================================+
| [ 🔍 Search for an item...          ]    | <- STICKY
| [ All ] [Cheaper↓] [Expensive↑] [Cat.▼]  | <- STICKY
+==========================================+
|                                          |
| ▼ 🏠 Daily Essentials                    |
|   ------------------------------------   |
|   🧴 Hair Oil, Shampoo... 18%→5% (↓13pp) |
|   🧈 Butter, Ghee...      12%→5% (↓7pp)  |
|                                          |
| ► 💊 Healthcare Relief                   |
|                                          |
| ► 🚜 Farmers & Agriculture               |
|                                          |
| ... (rest of the accordions)             |
|                                          |
|                                          |
|                                      +---+
+--------------------------------------|☰ Cat|
                                       +---+
                                        ^
                                   Floating button,
                                   opens a category list modal
```