// @ts-check
import { defineConfig } from 'astro/config';
import cloudflare from '@astrojs/cloudflare';
import sitemap from '@astrojs/sitemap';

import tailwindcss from '@tailwindcss/vite';

// https://astro.build/config
export default defineConfig({
  site: 'https://ladentdugeant.be',
  output: 'static',
  integrations: [
    sitemap({
      filter: (page) =>
        !page.includes("/accueil-test") && !page.includes("/index-v1"),
    }),
  ],

  adapter: cloudflare(),

  vite: {
    plugins: [tailwindcss()],
  },
});