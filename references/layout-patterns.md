# Aries Layout Patterns

This document contains the standard layout patterns for Aries-themed applications. Use these as templates when building new apps.

## Table of Contents

1. [Root Layout](#root-layout)
2. [App Shell (Sidebar + Header + Content)](#app-shell)
3. [Sidebar Component](#sidebar-component)
4. [Page Content Patterns](#page-content-patterns)

---

## Root Layout

The root layout (`src/app/layout.tsx`) loads the Inter font and applies it globally.

```tsx
import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({
  variable: "--font-inter",
  subsets: ["latin"],
  weight: ["300", "400", "500", "600", "700"],
});

export const metadata: Metadata = {
  title: "YOUR_APP_NAME",
  description: "YOUR_APP_DESCRIPTION",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className={`${inter.variable} font-sans antialiased`}>
        {children}
      </body>
    </html>
  );
}
```

Replace `YOUR_APP_NAME` and `YOUR_APP_DESCRIPTION` with the user's application name and description.

---

## App Shell

The app shell (`src/app/(app)/layout.tsx`) is the main authenticated layout with sidebar, header, and content area. All pages within the `(app)` route group use this layout.

```tsx
"use client";

import React from "react";
import { usePathname } from "next/navigation";
import { SidebarProvider, SidebarInset, SidebarTrigger } from "@/components/ui/sidebar";
import { AppSidebar } from "@/components/app-sidebar";
import { Separator } from "@/components/ui/separator";
import { Toaster } from "@/components/ui/sonner";
import {
  Breadcrumb,
  BreadcrumbList,
  BreadcrumbItem,
  BreadcrumbLink,
  BreadcrumbPage,
  BreadcrumbSeparator,
} from "@/components/ui/breadcrumb";
import Link from "next/link";

function toTitleCase(segment: string): string {
  return segment
    .replace(/-/g, " ")
    .replace(/\b\w/g, (char) => char.toUpperCase());
}

function HeaderBreadcrumb() {
  const pathname = usePathname();
  const segments = pathname.split("/").filter(Boolean);

  return (
    <Breadcrumb>
      <BreadcrumbList>
        {segments.map((segment, index) => {
          const isLast = index === segments.length - 1;
          const href = "/" + segments.slice(0, index + 1).join("/");

          return (
            <React.Fragment key={segment}>
              {index > 0 && <BreadcrumbSeparator />}
              <BreadcrumbItem>
                {isLast ? (
                  <BreadcrumbPage className="font-medium">
                    {toTitleCase(segment)}
                  </BreadcrumbPage>
                ) : (
                  <BreadcrumbLink asChild>
                    <Link href={href}>{toTitleCase(segment)}</Link>
                  </BreadcrumbLink>
                )}
              </BreadcrumbItem>
            </React.Fragment>
          );
        })}
      </BreadcrumbList>
    </Breadcrumb>
  );
}

export default function AppLayout({ children }: { children: React.ReactNode }) {
  return (
    <SidebarProvider>
      <AppSidebar />
      <Toaster />
      <SidebarInset className="min-w-0 overflow-x-hidden">
        <header className="sticky top-0 z-20 flex h-14 shrink-0 items-center gap-2 border-b bg-background px-4">
          <SidebarTrigger className="-ml-1" />
          <Separator orientation="vertical" className="mr-2 !h-4" />
          <HeaderBreadcrumb />
        </header>
        <main className="flex-1 p-6">
          {children}
        </main>
      </SidebarInset>
    </SidebarProvider>
  );
}
```

### Key conventions

- **Header height**: Always `h-14` (3.5rem / 56px)
- **Header**: Sticky, `z-20`, with border-bottom
- **Content padding**: Always `p-6` for the main area
- **SidebarInset**: Must have `min-w-0 overflow-x-hidden` to prevent horizontal scroll bugs
- **Breadcrumbs**: Auto-generated from the pathname — segments are title-cased
- **Toaster**: Mount the `<Toaster />` component inside the SidebarProvider for toast notifications

### Adding a header action button (optional)

If the app needs a global action in the header (like a search or AI assistant button), add it after the breadcrumb:

```tsx
<button
  onClick={handleAction}
  className="ml-auto inline-flex items-center gap-2 rounded-md border bg-muted/50 px-3 py-1.5 text-sm text-muted-foreground transition-colors hover:bg-muted hover:text-foreground"
>
  <IconName className="size-4 text-purple-500" />
  <span>Button Label</span>
  <kbd className="hidden rounded border bg-background px-1.5 py-0.5 font-mono text-[10px] font-medium sm:inline">
    ⌘K
  </kbd>
</button>
```

---

## Sidebar Component

The sidebar (`src/components/app-sidebar.tsx`) is the primary navigation element. It uses shadcn/ui's Sidebar components with the Aries dark navy styling.

```tsx
"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
// Import your icons from lucide-react as needed
import { LayoutDashboard, Settings } from "lucide-react";

import {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarGroup,
  SidebarHeader,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
} from "@/components/ui/sidebar";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";

// Define your navigation items
const NAV_ITEMS = [
  { label: "Dashboard", href: "/dashboard", icon: LayoutDashboard },
  // Add more items as needed...
  { label: "Settings", href: "/settings", icon: Settings },
];

export function AppSidebar() {
  const pathname = usePathname();

  return (
    <Sidebar className="border-r-0">
      {/* Header: App logo */}
      <SidebarHeader className="border-b border-slate-700 p-4">
        <Link
          href="/dashboard"
          className="flex items-center gap-2 hover:opacity-80 transition-opacity"
        >
          <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-aries-primary">
            {/* Replace with your app's logo/icon */}
            <span className="text-lg text-white">🐏</span>
          </div>
          <span className="text-xl font-semibold text-white">APP NAME</span>
        </Link>
      </SidebarHeader>

      {/* Navigation */}
      <SidebarContent>
        <SidebarGroup>
          <SidebarMenu>
            {NAV_ITEMS.map((item) => {
              const isActive = pathname === item.href;
              return (
                <SidebarMenuItem key={item.href}>
                  <SidebarMenuButton
                    asChild
                    isActive={isActive}
                    tooltip={item.label}
                  >
                    <Link href={item.href}>
                      <item.icon />
                      <span>{item.label}</span>
                    </Link>
                  </SidebarMenuButton>
                </SidebarMenuItem>
              );
            })}
          </SidebarMenu>
        </SidebarGroup>
      </SidebarContent>

      {/* Footer: User info */}
      <SidebarFooter className="border-t border-slate-700 p-4">
        <div className="flex items-center gap-3">
          <Avatar className="h-8 w-8">
            <AvatarFallback className="bg-slate-600 text-sm text-white">
              UN
            </AvatarFallback>
          </Avatar>
          <div className="flex-1 min-w-0">
            <div className="text-sm font-medium text-white truncate">
              User Name
            </div>
            <div className="text-xs text-slate-400 truncate">
              Role
            </div>
          </div>
        </div>
      </SidebarFooter>
    </Sidebar>
  );
}
```

### Sidebar conventions

- **No right border**: Always use `className="border-r-0"` on the Sidebar — the sidebar-to-content transition is seamless
- **Section borders**: Use `border-slate-700` for header/footer dividers (these show against the dark background)
- **Logo block**: 8x8 rounded-lg with `bg-aries-primary`, white icon/emoji inside
- **Brand name**: `text-xl font-semibold text-white`, all caps
- **User avatar**: `bg-slate-600 text-white` fallback, `h-8 w-8` size
- **Text colors**: White for primary text, `text-slate-400` for secondary text
- **Active state**: Handled automatically by shadcn's `isActive` prop on `SidebarMenuButton`
- **Icons**: Always use Lucide React icons, imported directly (not string-mapped)

### Sidebar responsive behavior

The shadcn sidebar system handles responsiveness automatically:
- **Desktop (md+)**: Fixed sidebar, 16rem wide (CSS variable `--sidebar-width`)
- **Mobile**: Sheet overlay, 18rem wide
- **Collapsed**: Icon-only mode, 3rem wide
- **Toggle**: `SidebarTrigger` component in the header, also responds to `⌘B` / `Ctrl+B`

---

## Page Content Patterns

### Dashboard / Overview page

Use a grid of cards with consistent spacing:

```tsx
export default function DashboardPage() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-heading-1">Dashboard</h1>
        <p className="text-body mt-1">Overview of your operations</p>
      </div>

      {/* KPI cards row */}
      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4">
        <Card>
          <CardHeader>
            <CardDescription>Total Revenue</CardDescription>
            <CardTitle className="text-2xl">$1,234,567</CardTitle>
          </CardHeader>
        </Card>
        {/* More KPI cards... */}
      </div>

      {/* Content cards */}
      <div className="grid gap-6 lg:grid-cols-2">
        <Card>
          <CardHeader>
            <CardTitle>Recent Activity</CardTitle>
          </CardHeader>
          <CardContent>
            {/* Content here */}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
```

### List / Table page

```tsx
export default function ListPage() {
  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-heading-1">Items</h1>
          <p className="text-body mt-1">Manage your items</p>
        </div>
        <Button>
          <Plus className="size-4" />
          Add Item
        </Button>
      </div>

      <Card>
        <CardContent className="p-0">
          <Table>
            {/* Table content */}
          </Table>
        </CardContent>
      </Card>
    </div>
  );
}
```

### Detail page

```tsx
export default function DetailPage() {
  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-heading-1">Item Name</h1>
          <p className="text-body mt-1">Item description or status</p>
        </div>
        <div className="flex gap-2">
          <Button variant="outline">Edit</Button>
          <Button variant="destructive">Delete</Button>
        </div>
      </div>

      <div className="grid gap-6 lg:grid-cols-3">
        <Card className="lg:col-span-2">
          <CardHeader>
            <CardTitle>Details</CardTitle>
          </CardHeader>
          <CardContent>
            {/* Main content */}
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Summary</CardTitle>
          </CardHeader>
          <CardContent>
            {/* Sidebar info */}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
```

### Page spacing rules

- **Page root**: Always `space-y-6` for vertical rhythm
- **Page title section**: `h1` with `text-heading-1`, optional `text-body` subtitle below with `mt-1`
- **Card grids**: Always `gap-6`, use `md:grid-cols-2` or `lg:grid-cols-4` etc.
- **Action buttons**: Top-right, aligned with page title via `flex items-center justify-between`
- **Tables inside cards**: Use `CardContent className="p-0"` to let the table fill edge-to-edge
