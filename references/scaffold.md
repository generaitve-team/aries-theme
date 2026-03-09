# Scaffolding a New Aries Project

Step-by-step instructions for creating a new Next.js project with the Aries design system from scratch. Follow these steps in order.

## Step 1: Create the Next.js project

```bash
npx create-next-app@latest my-app \
  --typescript \
  --tailwind \
  --eslint \
  --app \
  --src-dir \
  --import-alias "@/*" \
  --turbopack
```

Then `cd my-app`.

## Step 2: Install dependencies

```bash
# Core UI dependencies
npm install lucide-react class-variance-authority clsx tailwind-merge sonner next-themes motion

# shadcn/ui (dev dependency — the CLI tool)
npm install -D shadcn tw-animate-css
```

## Step 3: Initialize shadcn/ui

```bash
npx shadcn@latest init
```

When prompted, accept defaults. This creates the base configuration. Then install the core components used by the Aries layout:

```bash
npx shadcn@latest add sidebar button card separator breadcrumb avatar badge sonner tooltip
```

Install additional components as needed for the specific application:

```bash
# Common additions (install as needed)
npx shadcn@latest add input label textarea select form
npx shadcn@latest add table dialog sheet dropdown-menu
npx shadcn@latest add tabs checkbox switch scroll-area
npx shadcn@latest add skeleton progress collapsible
```

## Step 4: Replace globals.css

Replace the contents of `src/app/globals.css` with the Aries theme file from `references/globals.css` in this skill. Copy it verbatim — every token matters.

## Step 5: Update postcss.config.mjs

Ensure `postcss.config.mjs` contains:

```js
const config = {
  plugins: {
    "@tailwindcss/postcss": {},
  },
};

export default config;
```

## Step 6: Set up the root layout

Replace `src/app/layout.tsx`:

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
  title: "APP_NAME",
  description: "APP_DESCRIPTION",
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

## Step 7: Create the cn() utility

Create `src/lib/utils.ts`:

```ts
import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

## Step 8: Create the app shell layout

Create the `(app)` route group with the sidebar layout. See `references/layout-patterns.md` for the complete app shell and sidebar component code.

Files to create:
- `src/app/(app)/layout.tsx` — The app shell with SidebarProvider, header, and content area
- `src/components/app-sidebar.tsx` — The dark navy sidebar with navigation
- `src/app/(app)/dashboard/page.tsx` — The default landing page

## Step 9: Create a redirect from root

Create `src/app/page.tsx` to redirect to the default page:

```tsx
import { redirect } from "next/navigation";

export default function Home() {
  redirect("/dashboard");
}
```

## Step 10: Verify

Run `npm run dev` and check:

- [ ] Dark navy sidebar renders on the left
- [ ] Logo block with blue background in sidebar header
- [ ] White navigation text with Lucide icons
- [ ] Sticky header with sidebar toggle and breadcrumbs
- [ ] Inter font is applied globally
- [ ] Cards have rounded corners and subtle shadows
- [ ] Blue primary color on buttons and interactive elements

## Project structure after scaffold

```
src/
├── app/
│   ├── globals.css          ← Aries theme (from references/globals.css)
│   ├── layout.tsx           ← Root layout with Inter font
│   ├── page.tsx             ← Redirect to /dashboard
│   └── (app)/
│       ├── layout.tsx       ← App shell (sidebar + header + content)
│       └── dashboard/
│           └── page.tsx     ← First page
├── components/
│   ├── app-sidebar.tsx      ← Dark navy sidebar
│   └── ui/                  ← shadcn/ui components (do not edit directly)
└── lib/
    └── utils.ts             ← cn() utility
```

## Adding pages

To add a new page:

1. Create the route under `src/app/(app)/your-page/page.tsx`
2. Add a nav item to the `NAV_ITEMS` array in `app-sidebar.tsx`
3. Import the appropriate Lucide icon
4. The breadcrumb will auto-generate from the URL path

Follow the page content patterns in `references/layout-patterns.md` for consistent structure.
