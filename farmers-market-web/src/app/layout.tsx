// src/app/layout.tsx
'use client';

import { Inter } from 'next/font/google';
import './globals.css';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { useEffect } from 'react';

const inter = Inter({ subsets: ['latin'] });

const queryClient = new QueryClient();

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  useEffect(() => {
    // Any initialization that needs to happen after hydration
  }, []);

  return (
    <html lang="en" suppressHydrationWarning>
      <QueryClientProvider client={queryClient}>
        <body className={inter.className} suppressHydrationWarning>
          <div suppressHydrationWarning>{children}</div>
        </body>
      </QueryClientProvider>
    </html>
  );
}
