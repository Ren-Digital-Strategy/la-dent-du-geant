import type { APIRoute } from "astro";
import { fetchGoogleReviews, type FormattedReview } from "../../lib/google-business";

export const prerender = false;

// Cache simple en mémoire pour éviter trop d'appels API
let cachedReviews: {
  data: FormattedReview[];
  totalCount: number;
  averageRating: number;
  timestamp: number;
} | null = null;

const CACHE_DURATION = 1000 * 60 * 60; // 1 heure

export const GET: APIRoute = async ({ url, locals }) => {
  const limit = parseInt(url.searchParams.get("limit") || "5");
  const env = (locals as any)?.runtime?.env ?? import.meta.env;

  try {
    // Vérifier le cache
    if (cachedReviews && Date.now() - cachedReviews.timestamp < CACHE_DURATION) {
      return new Response(
        JSON.stringify({
          reviews: cachedReviews.data.slice(0, limit),
          totalCount: cachedReviews.totalCount,
          averageRating: cachedReviews.averageRating,
          cached: true,
        }),
        {
          status: 200,
          headers: {
            "Content-Type": "application/json",
            "Cache-Control": "public, max-age=3600",
          },
        }
      );
    }

    // Récupérer les avis depuis Google Places
    const { reviews, totalCount, averageRating } = await fetchGoogleReviews(env);

    // Mettre en cache
    cachedReviews = {
      data: reviews,
      totalCount,
      averageRating,
      timestamp: Date.now(),
    };

    return new Response(
      JSON.stringify({
        reviews: reviews.slice(0, limit),
        totalCount,
        averageRating,
        cached: false,
      }),
      {
        status: 200,
        headers: {
          "Content-Type": "application/json",
          "Cache-Control": "public, max-age=3600",
        },
      }
    );
  } catch (error) {
    console.error("Error fetching reviews:", error);

    // Retourner le cache même expiré en cas d'erreur
    if (cachedReviews) {
      return new Response(
        JSON.stringify({
          reviews: cachedReviews.data.slice(0, limit),
          totalCount: cachedReviews.totalCount,
          averageRating: cachedReviews.averageRating,
          cached: true,
          stale: true,
        }),
        {
          status: 200,
          headers: { "Content-Type": "application/json" },
        }
      );
    }

    return new Response(
      JSON.stringify({
        error: "Failed to fetch reviews",
        message: error instanceof Error ? error.message : "Unknown error",
      }),
      {
        status: 500,
        headers: { "Content-Type": "application/json" },
      }
    );
  }
};
