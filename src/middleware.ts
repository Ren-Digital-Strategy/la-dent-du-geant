import { defineMiddleware } from 'astro:middleware';

const LEGACY_HOST = 'ladentdugeant.dimagin.studio';
const CANONICAL_ORIGIN = 'https://ladentdugeant.be';

export const onRequest = defineMiddleware(async (context, next) => {
  const host =
    context.request.headers.get('x-forwarded-host') ??
    context.request.headers.get('host') ??
    context.url.hostname;

  if (host.toLowerCase() === LEGACY_HOST) {
    const target = new URL(context.url.pathname + context.url.search, CANONICAL_ORIGIN);
    return new Response(null, {
      status: 301,
      headers: {
        Location: target.toString(),
      },
    });
  }

  return next();
});
