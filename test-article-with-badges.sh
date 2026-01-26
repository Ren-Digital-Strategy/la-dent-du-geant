#!/bin/bash

# Script pour tester la création d'un article avec badges
# Usage: ./test-article-with-badges.sh

DIRECTUS_URL="http://localhost:8055"

echo "📝 Création d'un article de test avec badges..."

# D'abord, récupérer l'ID d'un badge existant
echo "Récupération des badges disponibles..."
BADGE_RESPONSE=$(curl -s "$DIRECTUS_URL/items/badges?filter[status][_eq]=published&limit=2")
echo "Badges disponibles: $BADGE_RESPONSE"
echo ""

# Extraire les IDs des badges (utilise jq si disponible, sinon affiche juste la réponse)
if command -v jq &> /dev/null; then
  BADGE_ID_1=$(echo "$BADGE_RESPONSE" | jq -r '.data[0].id')
  BADGE_ID_2=$(echo "$BADGE_RESPONSE" | jq -r '.data[1].id')
  
  echo "Badge 1 ID: $BADGE_ID_1"
  echo "Badge 2 ID: $BADGE_ID_2"
  echo ""
  
  # Créer un article avec ces badges
  echo "Création de l'article..."
  curl -X POST "$DIRECTUS_URL/items/blog" \
    -H "Content-Type: application/json" \
    -d "{
      \"titre\": \"Article de test avec badges\",
      \"description\": \"Ceci est un article de test pour vérifier le fonctionnement des badges et du temps de lecture.\",
      \"contenu\": \"<h2>Introduction</h2><p>Ceci est le contenu de l'article de test.</p><h2>Section 1</h2><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p><h2>Conclusion</h2><p>Merci d'avoir lu cet article.</p>\",
      \"auteur_nom\": \"Dr. Test\",
      \"auteur_profession\": \"Dentiste\",
      \"status\": \"published\",
      \"temps_lecture\": 3,
      \"badges\": [
        {\"badges_id\": \"$BADGE_ID_1\"},
        {\"badges_id\": \"$BADGE_ID_2\"}
      ]
    }"
  
  echo ""
  echo "✅ Article créé avec succès!"
else
  echo "⚠️  jq n'est pas installé. Impossible d'extraire automatiquement les IDs des badges."
  echo "Vous pouvez installer jq avec: brew install jq"
  echo ""
  echo "Ou créer manuellement un article dans Directus:"
  echo "1. Allez sur http://localhost:8055"
  echo "2. Ouvrez la collection Blog"
  echo "3. Créez un nouvel article"
  echo "4. Ajoutez des badges et un temps de lecture"
fi

echo ""
echo "Pour voir le résultat:"
echo "- Frontend: http://localhost:4321/blog"
echo "- Directus: http://localhost:8055/admin/content/blog"
