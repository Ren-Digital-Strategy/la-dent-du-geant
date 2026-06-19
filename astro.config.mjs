// @ts-check
import { defineConfig } from 'astro/config';
import node from '@astrojs/node';
import sitemap from '@astrojs/sitemap';

import tailwindcss from '@tailwindcss/vite';

// https://astro.build/config
export default defineConfig({
  site: 'https://www.ladentdugeant.be',
  output: 'server',
  integrations: [
    sitemap({
      filter: (page) =>
        !page.includes("/accueil-test") && !page.includes("/index-v1"),
    }),
  ],

  adapter: node({
    mode: 'standalone',
  }),

  vite: {
    plugins: [tailwindcss()],
  },
});