# Aries Baseline Components

This file lists the 27 shadcn/ui components that form the Aries baseline kit. Every Aries project should have these components installed. Additional components can be added as needed for specific features.

## Installation

Install all baseline components in a single command:

```bash
npx shadcn@4 add alert avatar badge breadcrumb button card checkbox collapsible command dialog dropdown-menu form input label progress scroll-area select separator sheet sidebar skeleton sonner switch table tabs textarea tooltip
```

This command is safe to re-run -- it will skip components that are already installed.

## Component Usage Notes

Each component below has a brief note on when and how to use it in the Aries design system.

- **alert** -- System messages and inline notifications. Use for important information that should not be dismissed.
- **avatar** -- User profile images. Used in the sidebar footer and anywhere a person is represented.
- **badge** -- Status indicators and category tags. Use variant="default" for informational, "destructive" for errors, "outline" for neutral labels.
- **breadcrumb** -- Navigation context in the app shell header. Shows the current page location.
- **button** -- Interactive actions. Use variant="default" for primary actions (renders in blue), "outline" for secondary actions, "ghost" for tertiary or icon-only buttons.
- **card** -- Primary content container. Use for any grouped content section -- metrics, forms, detail panels, lists. Cards provide visual boundaries and consistent spacing.
- **checkbox** -- Boolean selections in forms and lists. Use within Form components with proper labels.
- **collapsible** -- Expandable content sections. Used in sidebar navigation for nested menu items.
- **command** -- Command palette (Cmd+K / Ctrl+K). Provides search and quick-action functionality across the application.
- **dialog** -- Modal confirmations and small forms. Use for actions that require user confirmation or brief data entry. Not for full-page forms.
- **dropdown-menu** -- Context menus and action menus. Use for "more actions" buttons and right-click menus on table rows or cards.
- **form** -- Form wrapper with react-hook-form integration. Always use Form with zod validation for any data entry.
- **input** -- Text inputs for forms. Always pair with a Label and use within a Form component.
- **label** -- Form field labels. Rendered with the text-label utility class for consistency.
- **progress** -- Progress bars for completion indicators, upload progress, and percentage metrics.
- **scroll-area** -- Custom scrollable containers. Use when content may overflow in a fixed-height area.
- **select** -- Dropdown selections in forms and filter bars. Use within Form for validated selections.
- **separator** -- Visual dividers. Use to separate form sections, sidebar zones, and content groups.
- **sheet** -- Slide-out side panels. Use for supplementary content, detail views, or secondary forms that should not replace the current page.
- **sidebar** -- Dark navy application shell sidebar. Only use for full-application layouts that need persistent navigation.
- **skeleton** -- Loading placeholder shapes. Match the shape of the content being loaded (rectangle for text, circle for avatars, etc.).
- **sonner** -- Toast notifications. Use `toast.success()` for confirmations, `toast.error()` for failures, `toast.info()` for informational messages.
- **switch** -- Toggle controls for boolean settings. Use in settings pages and configuration forms.
- **table** -- Data tables with header, body, and row components. Pair with text-label styled column headers.
- **tabs** -- Page and section organization. Use for detail pages with multiple content categories.
- **textarea** -- Multi-line text input for descriptions, notes, and comments. Use within Form components.
- **tooltip** -- Contextual help text on hover. Every icon-only button must have a tooltip explaining its action.

## Adding Components Beyond the Baseline

If the user asks for functionality that requires a component not in the baseline list (for example, a carousel, calendar, chart, or accordion), install it on demand:

```bash
npx shadcn@4 add [component-name]
```

Before installing, check the shadcn MCP server (if available) to verify the component exists and review its API. If the MCP server is not available, check the shadcn/ui documentation at https://ui.shadcn.com/docs/components.

Do not pre-install components speculatively. Only add components when there is a concrete need for them in the current feature being built.
