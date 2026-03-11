# Aries Component Guide

How to use shadcn/ui components with the Aries design system. These conventions ensure visual consistency across all Aries-branded applications.

## Table of Contents

1. [Required Utility: cn()](#required-utility)
2. [Buttons](#buttons)
3. [Cards](#cards)
4. [Tables](#tables)
5. [Forms](#forms)
6. [Badges](#badges)
7. [Alerts & Status Colors](#alerts--status-colors)
8. [Typography](#typography)
9. [Icons](#icons)
10. [Dialogs & Sheets](#dialogs--sheets)
11. [Toasts](#toasts)

---

## Required Utility

Every Aries project needs the `cn()` class-merging utility at `src/lib/utils.ts`:

```ts
import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

Use `cn()` anywhere you conditionally combine Tailwind classes.

---

## Buttons

Install: `npx shadcn@latest add button`

### Variant usage

| Variant | When to use | Example |
|---------|------------|---------|
| `default` | Primary actions (save, create, submit) | "Save Changes", "Create Project" |
| `secondary` | Secondary actions alongside a primary | "Cancel", "Back" |
| `outline` | Tertiary actions, filters, toggles | "Edit", "Export" |
| `destructive` | Destructive/dangerous actions | "Delete", "Remove" |
| `ghost` | Inline or minimal actions | Icon-only buttons, table row actions |
| `link` | Text-style navigation that looks like a link | "View all", "Learn more" |

### Size usage

| Size | When to use |
|------|------------|
| `default` | Standard buttons in forms and actions |
| `sm` | Table row actions, compact areas |
| `lg` | Hero actions, prominent CTAs |
| `icon` | Icon-only buttons (32x32) |

> **Note:** If you need smaller icon buttons (`icon-sm` at 28x28 or `icon-xs` at 24x24), add these size variants to `src/components/ui/button.tsx` in the `buttonVariants` size map:
> ```ts
> "icon-sm": "size-8",
> "icon-xs": "size-6 rounded-md [&_svg:not([class*='size-'])]:size-3",
> ```

### Examples

```tsx
import { Button } from "@/components/ui/button";
import { Plus, Trash2, Download } from "lucide-react";

// Primary action with icon
<Button>
  <Plus className="size-4" />
  Add Item
</Button>

// Destructive in a dialog footer
<Button variant="destructive">
  <Trash2 className="size-4" />
  Delete
</Button>

// Icon-only ghost button
<Button variant="ghost" size="icon-sm">
  <Download className="size-4" />
</Button>
```

---

## Cards

Install: `npx shadcn@latest add card`

Cards are the primary content container in Aries. The composition pattern is:

```tsx
import {
  Card,
  CardHeader,
  CardTitle,
  CardDescription,
  CardContent,
  CardFooter,
} from "@/components/ui/card";

<Card>
  <CardHeader>
    <CardTitle>Card Title</CardTitle>
    <CardDescription>Optional subtitle or description</CardDescription>
  </CardHeader>
  <CardContent>
    {/* Main content */}
  </CardContent>
  <CardFooter>
    {/* Optional footer with actions */}
  </CardFooter>
</Card>
```

### Card conventions

- **Default styling**: Rounded-xl, border, subtle shadow (`shadow-sm`)
- **Padding**: `py-6` on the card, `px-6` on header/content/footer
- **Gap**: `gap-6` between card header sections
- **KPI cards**: Use a `<span className="text-label">` for the metric label (renders uppercase, small, muted) and `CardTitle` with `text-2xl` for the value. Do NOT use `CardDescription` for KPI labels — it renders as body text, not the uppercase label style.
- **Table cards**: Use `CardContent className="p-0"` to let tables bleed to edges
- **No nested cards**: Cards should not contain other cards — use sections within a card instead

---

## Tables

Install: `npx shadcn@latest add table`

Tables are always wrapped in a Card with no padding:

```tsx
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";

<Card>
  <CardHeader>
    <CardTitle>Items</CardTitle>
  </CardHeader>
  <CardContent className="p-0">
    <Table>
      <TableHeader>
        <TableRow>
          <TableHead>Name</TableHead>
          <TableHead>Status</TableHead>
          <TableHead className="text-right">Amount</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        <TableRow>
          <TableCell className="font-medium">Item name</TableCell>
          <TableCell><Badge variant="secondary">Active</Badge></TableCell>
          <TableCell className="text-right">$1,234</TableCell>
        </TableRow>
      </TableBody>
    </Table>
  </CardContent>
</Card>
```

### Table conventions

- **Always in a Card**: Never render a bare table — wrap it in Card with `p-0` CardContent
- **Right-align numbers**: Currency, percentages, counts get `text-right`
- **Font-medium for primary column**: The first/main column gets `font-medium`
- **Status via Badge**: Use `Badge` components for status indicators in table cells
- **Row actions**: Ghost icon buttons aligned right, usually in a flex container

---

## Forms

Install: `npx shadcn@latest add input label textarea select form`

```tsx
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";

// Standard form field pattern
<div className="space-y-2">
  <Label htmlFor="name">Project Name</Label>
  <Input id="name" placeholder="Enter project name" />
</div>

// Form in a card
<Card>
  <CardHeader>
    <CardTitle>Create Item</CardTitle>
  </CardHeader>
  <CardContent className="space-y-4">
    <div className="space-y-2">
      <Label>Name</Label>
      <Input placeholder="Enter name" />
    </div>
    <div className="space-y-2">
      <Label>Description</Label>
      <Textarea placeholder="Enter description" />
    </div>
    <div className="space-y-2">
      <Label>Status</Label>
      <Select>
        <SelectTrigger>
          <SelectValue placeholder="Select status" />
        </SelectTrigger>
        <SelectContent>
          <SelectItem value="active">Active</SelectItem>
          <SelectItem value="inactive">Inactive</SelectItem>
        </SelectContent>
      </Select>
    </div>
  </CardContent>
  <CardFooter className="flex justify-end gap-2">
    <Button variant="outline">Cancel</Button>
    <Button>Save</Button>
  </CardFooter>
</Card>
```

### Form conventions

- **Field spacing**: `space-y-4` between form fields, `space-y-2` between label and input
- **Labels above inputs**: Always use `Label` above the field, not inline
- **Footer actions**: Right-aligned with `flex justify-end gap-2`, primary button last
- **Validation**: Use `aria-invalid` states — shadcn inputs automatically show destructive ring on `aria-invalid`

---

## Badges

Install: `npx shadcn@latest add badge`

```tsx
import { Badge } from "@/components/ui/badge";

<Badge>Default</Badge>
<Badge variant="secondary">Secondary</Badge>
<Badge variant="outline">Outline</Badge>
<Badge variant="destructive">Destructive</Badge>
```

### Status badge patterns

For business status indicators, use these consistent color mappings:

```tsx
// Active / On Track — primary blue
<Badge className="bg-blue-100 text-blue-700 border-blue-200">Active</Badge>

// Completed / Done — green
<Badge className="bg-green-100 text-green-700 border-green-200">Completed</Badge>

// At Risk / Warning / Pending — amber (NOT red)
<Badge className="bg-amber-100 text-amber-700 border-amber-200">At Risk</Badge>

// On Hold / Paused — gray
<Badge variant="secondary">On Hold</Badge>

// Error / Critical / Overdue — red (only for failures)
<Badge className="bg-red-100 text-red-700 border-red-200">Overdue</Badge>
```

Red means broken or failed. At-risk items are amber — they need attention but aren't failures.

---

## Alerts & Status Colors

The Aries status color system uses three semantic levels:

| Level | Label | Colors | Use for |
|-------|-------|--------|---------|
| Error/Urgent | "Urgent" | Red — `border-l-red-500`, `bg-red-100 text-red-700` | Expiring items, blocked work, critical failures |
| Warning | "Warning" | Amber — `border-l-amber-500`, `bg-amber-100 text-amber-700` | Budget variance, sync issues, approaching deadlines |
| Info/Review | "Review" | Blue — `border-l-blue-500`, `bg-blue-100 text-blue-700` | Pending approvals, items ready for review |

### Alert card pattern

```tsx
<div className="rounded-lg border border-l-4 border-l-red-500 p-4">
  <div className="flex items-start gap-3">
    <AlertCircle className="size-5 text-red-500 mt-0.5" />
    <div>
      <div className="font-medium">Alert Title</div>
      <div className="text-sm text-muted-foreground mt-1">
        Description of the alert with details.
      </div>
    </div>
    <Badge className="ml-auto bg-red-100 text-red-700 border-red-200">
      Urgent
    </Badge>
  </div>
</div>
```

### Aries brand colors (via CSS custom properties)

These are available as Tailwind classes after loading the Aries theme:

- `bg-aries-navy` / `text-aries-navy` — Dark navy (sidebar background)
- `bg-aries-navy-light` — Lighter navy (sidebar hover)
- `bg-aries-primary` / `text-aries-primary` — Brand blue (accents, active states)
- `bg-aries-success` / `text-aries-success` — Green (success states)
- `bg-aries-warning` / `text-aries-warning` — Amber (warning states)
- `bg-aries-danger` / `text-aries-danger` — Red (error/danger states)

---

## Typography

Use the built-in typography utility classes defined in globals.css:

| Class | Renders as | Use for |
|-------|-----------|---------|
| `.text-heading-1` | 2xl, semibold, tight tracking | Page titles |
| `.text-heading-2` | xl, semibold, tight tracking | Section titles |
| `.text-heading-3` | lg, medium weight | Sub-section titles |
| `.text-body` | sm, muted foreground | Body text, descriptions |
| `.text-label` | xs, medium, uppercase, wide tracking, muted | Labels above data, category headers |

Always use the utility classes above instead of writing ad-hoc Tailwind text styles. This ensures consistency and makes future theme changes propagate automatically.

---

## Icons

Always use **Lucide React** for icons. Import only what you need:

```tsx
import { Plus, Trash2, Settings, ChevronRight, Search } from "lucide-react";

// Standard icon sizing
<Plus className="size-4" />      // 16px — inside buttons, inline
<Settings className="size-5" />  // 20px — standalone, alerts
<ChevronRight className="size-3" /> // 12px — small indicators
```

### Icon conventions

- **In buttons**: `size-4`, placed before the label
- **In table actions**: `size-4` inside `ghost` `icon-sm` buttons
- **In alerts/cards**: `size-5`
- **Chevrons/arrows**: `size-3` to `size-4`
- **Color**: Inherit from parent text color unless specifically colored (e.g., `text-red-500` for destructive)

---

## Dialogs & Sheets

Install: `npx shadcn@latest add dialog sheet`

Use **Dialog** for focused actions (create, edit, confirm delete). Use **Sheet** for side panels with more content.

```tsx
// Confirmation dialog
<Dialog>
  <DialogTrigger asChild>
    <Button variant="destructive" size="sm">Delete</Button>
  </DialogTrigger>
  <DialogContent>
    <DialogHeader>
      <DialogTitle>Delete Item</DialogTitle>
      <DialogDescription>
        This action cannot be undone. Are you sure?
      </DialogDescription>
    </DialogHeader>
    <DialogFooter>
      <Button variant="outline">Cancel</Button>
      <Button variant="destructive">Delete</Button>
    </DialogFooter>
  </DialogContent>
</Dialog>
```

---

## Toasts

Install: `npx shadcn@latest add sonner`

Mount `<Toaster />` once in the app shell layout. Then use `toast()` from sonner:

```tsx
import { toast } from "sonner";

// Success toast
toast.success("Item created successfully");

// Error toast
toast.error("Failed to save changes");

// With description
toast("Item updated", {
  description: "Your changes have been saved.",
});
```

### Toast conventions

- Mount `<Toaster />` inside the `SidebarProvider` in the app layout
- Use `toast.success()` for confirmations of completed actions
- Use `toast.error()` for failed operations
- Keep messages short — one line for the title, optional one-line description
