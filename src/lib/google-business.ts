// Utilitaires pour l'API Google Places (New)

export interface FormattedReview {
  id: string;
  rating: number;
  text: string;
  author: string;
  image: string;
  date: string;
}

interface PlacesReviewNew {
  name: string;
  relativePublishTimeDescription: string;
  rating: number;
  text?: {
    text: string;
    languageCode: string;
  };
  originalText?: {
    text: string;
    languageCode: string;
  };
  authorAttribution: {
    displayName: string;
    uri: string;
    photoUri: string;
  };
  publishTime: string;
}

interface PlaceDetailsResponseNew {
  reviews?: PlacesReviewNew[];
  rating?: number;
  userRatingCount?: number;
  displayName?: {
    text: string;
    languageCode: string;
  };
}

/**
 * Récupère les avis via l'API Google Places (New)
 * Limite: maximum 5 avis retournés par Google
 */
export async function fetchGoogleReviews(
  env: Record<string, any> = import.meta.env
): Promise<{
  reviews: FormattedReview[];
  totalCount: number;
  averageRating: number;
}> {
  const apiKey = env.GOOGLE_PLACES_API_KEY;
  const placeId = env.GOOGLE_PLACE_ID;

  if (!apiKey) {
    throw new Error("GOOGLE_PLACES_API_KEY is not set");
  }

  if (!placeId) {
    throw new Error("GOOGLE_PLACE_ID is not set");
  }

  // Nouvelle API Places (v1)
  const url = `https://places.googleapis.com/v1/places/${placeId}?languageCode=fr`;

  const response = await fetch(url, {
    headers: {
      "Content-Type": "application/json",
      "X-Goog-Api-Key": apiKey,
      "X-Goog-FieldMask": "reviews,rating,userRatingCount,displayName",
    },
  });

  if (!response.ok) {
    const errorText = await response.text();
    throw new Error(`Places API error: ${response.status} - ${errorText}`);
  }

  const data: PlaceDetailsResponseNew = await response.json();

  const reviews: FormattedReview[] = (data.reviews || [])
    .filter((review) => review.rating >= 3 && (review.text?.text || review.originalText?.text))
    .map((review, index) => ({
      id: review.name || `review-${index}`,
      rating: review.rating,
      text: review.text?.text || review.originalText?.text || "",
      author: review.authorAttribution.displayName,
      image: review.authorAttribution.photoUri || "/default-avatar.svg",
      date: review.relativePublishTimeDescription,
    }));

  return {
    reviews,
    totalCount: data.userRatingCount || 0,
    averageRating: data.rating || 0,
  };
}
