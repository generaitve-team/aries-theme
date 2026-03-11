# Aries Visual Patterns

This file describes the visual DNA of the Aries design system. These are prose descriptions of how Aries pages look and feel -- not copy-paste code snippets. When building any UI, read these patterns and adapt them to what the user is asking for. The patterns are flexible guidelines, not rigid templates.

## App Shell Layout

The Aries app shell uses the shadcn SidebarProvider and SidebarInset pattern. A dark navy sidebar sits on the left side of the screen. The sidebar has no visible right border -- the dark background provides visual separation from the light content area.

The sidebar has three vertical sections. The SidebarHeader contains the brand block: a blue square (h-8 w-8 rounded-lg bg-aries-primary) with a white ram emoji inside, followed by the app name in white, uppercase, text-xl font-semibold. Use the user's app name; default to "ARIES" if none given. The header is separated from the content below by a subtle border in sidebar-border. The SidebarContent holds the main navigation as a SidebarMenu with SidebarMenuButton items. Each nav item shows a Lucide icon and label in white text — the font is Inter (inherited from the theme's --font-sans), text-sm, medium weight. Active navigation items use the isActive state which applies a subtle lighter navy background (sidebar-accent). The SidebarFooter displays a user avatar (h-8 w-8, bg-slate-600 fallback with white initials) and the user's name in white text-sm font-medium, with their role below in text-xs text-slate-400. The footer is separated from the content above by a border in sidebar-border.

To the right of the sidebar, SidebarInset contains a sticky header bar and the main content area. The header includes a SidebarTrigger button (to collapse/expand the sidebar), a vertical Separator, and Breadcrumb navigation showing the current location. The main content area below the header has p-6 padding on all sides.

## Dashboard Card Pattern

Every page starts with a title using text-heading-1 followed by a subtitle in text-body. The subtitle is required, not optional — it gives context (e.g., "Overview of your projects and key metrics"). Never render a page title without a text-body line below it.

KPI/metric cards use the shadcn Card component. Each card has a CardHeader containing a label styled with text-label and a value in text-2xl font-semibold. KPI cards are intentionally minimal — label and value only. Do not add decorative icons, illustrations, or graphics to KPI cards. Optional change indicators (e.g., +24.5%) use a small Badge.

Cards are arranged in a responsive grid. On small screens they stack vertically in a single column. On medium screens they form two columns, and on large screens four columns. The grid uses gap-6 spacing between cards.

Below the KPI row, additional content cards (activity feeds, charts, tables) use text-heading-3 for their card titles via CardTitle. Always use the themed utility classes — never set font sizes or colors with arbitrary Tailwind values when a utility class exists.

## Data Table Pattern

Data tables use the shadcn Table component for simple tabular data. Column headers in the TableHeader use the text-label utility for consistent styling with the rest of the application. Table rows in the TableBody have hover states for interactivity. When rows have associated actions (edit, delete, view), place action buttons in the last column.

Above the table, an optional filter bar provides search and filtering. This bar typically contains an Input for text search and one or more Select dropdowns for categorical filters. The filter bar sits directly above the table with appropriate spacing.

For tables that need sorting, pagination, or complex filtering, use the tanstack/react-table library with the shadcn Table component for rendering. The shadcn Table provides the visual structure while tanstack/react-table handles the data logic.

## Form Layout Pattern

Forms use the shadcn Form component with react-hook-form for state management and zod for validation. Labels use the text-label utility class. All inputs, selects, and textareas come from shadcn components.

When a form has multiple sections (e.g., "General Information" and "Contact Details"), separate them with the shadcn Separator component. Each section can have its own heading using text-heading-3.

The submit button uses the Button component with variant="default", which renders in the primary blue color. Cancel or secondary actions use variant="outline". Place action buttons at the bottom of the form, right-aligned.

Forms are visually contained inside a Card component. The CardHeader holds the form title, and the CardContent holds the form fields. This gives forms a clear visual boundary on the page.

## Detail Page Pattern

Detail pages show comprehensive information about a single item (a project, a person, a record). The page has a header area with a back navigation link, the item's title in text-heading-1 with an inline status Badge, and a text-body description below.

Content is organized using the shadcn Tabs component (TabsList + TabsTrigger + TabsContent). Each tab groups related information -- for example, "Overview", "Budget", "Team". This is the standard pattern for detail pages — always use Tabs, not a flat page with sections. Every tab must have meaningful content — do not leave tabs empty or stub them out. If you create a tab, populate it.

Within each TabsContent, arrange Cards in a two-column grid using `grid gap-6 lg:grid-cols-3` with `lg:col-span-2` on the primary card (65/35 split). This layout is required — do not use three equal columns or a single-column stack on desktop. The wider left card holds rich, detailed content (lists, tables, descriptions), not just a single metric. The narrower right card holds supplementary quick-reference data.

The header area may include quick stats, status badges, or action buttons inline with the title.

## Kanban / Pipeline Pattern

Pipeline views display items moving through stages as horizontal columns. Each column represents a stage and has a header showing the stage name and a count badge indicating how many items are in that stage.

Within each column, items appear as cards showing key information: a title, a subtitle or description snippet, and optionally a status badge. Cards within a column are separated by gap-3 spacing. Columns themselves are separated by gap-4 spacing.

Drag-and-drop between columns is optional and depends on the use case. The visual layout works with or without interactivity.

## Color Usage Guidelines

Primary actions and interactive elements use the primary color tokens: bg-primary with text-primary-foreground. This renders as the Aries blue, which is the main accent color throughout the application.

For status indicators, use the Aries semantic color tokens with consistent mapping:

- **Active / On Track**: bg-primary text-primary-foreground (blue badge)
- **At Risk / Warning**: text-aries-warning or bg-amber-100 text-amber-800 (amber — not red)
- **Completed / Done**: bg-muted text-muted-foreground (gray)
- **On Hold / Paused**: bg-muted text-muted-foreground (gray)
- **Error / Critical / Overdue**: text-aries-danger or bg-destructive text-destructive-foreground (red)

Red means something is broken or failed. At-risk items are amber — they need attention but aren't failures.

Secondary and muted text uses text-muted-foreground. This is the standard color for descriptions, helper text, timestamps, and any text that should be visually subordinate to the main content.

Card borders use the default border utility, which picks up the theme's border color. The sidebar uses the navy background color from the theme -- this is handled automatically by the shadcn sidebar tokens and does not need manual color application.

## Typography Guidelines

The entire Aries application uses the Inter font family. This is set globally via the --font-sans CSS variable which maps to --font-inter (loaded in the root layout via next/font/google). Every element — navigation, headings, body text, labels, buttons — renders in Inter. If text looks like a system font or serif, the font setup is wrong.

The Aries type system uses five utility classes that ensure consistent text styling across the application:

Page titles use the text-heading-1 class, which sets the text to 2xl size with semibold weight and tight letter tracking. This is for the main title at the top of every page.

Section titles use text-heading-2, which is xl size with semibold weight and tight tracking. Use this for major sections within a page.

Card titles and subsection headings use text-heading-3, which is lg size with medium weight. This is appropriate for Card headers and smaller groupings of content.

Body text uses the text-body class, which sets sm size with muted-foreground color. This is the default for paragraphs, descriptions, and general content text.

Labels and captions use the text-label class, which renders as xs size, medium weight, uppercase, with wide letter tracking and muted-foreground color. Use this for column headers in tables, metric labels in dashboard cards, form field labels, and any small categorical text.

## Spacing and Layout

Page content areas use p-6 padding on all sides. This creates consistent margins between the content and the edges of the viewport or sidebar.

Cards in grid layouts use gap-6 spacing between them. Inner card padding follows the shadcn Card defaults via CardContent.

Major sections within a page are separated with space-y-6 vertical spacing. This applies between the page title and the first content block, between card grids and tables, and between distinct content sections.

The base border radius is set by the theme's --radius variable at 0.625rem (10px). This scales automatically for different component sizes through the radius scale (radius-sm, radius-md, radius-lg, etc.). Do not override border radius values -- use the theme defaults.
