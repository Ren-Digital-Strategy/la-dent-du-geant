#!/bin/bash

# Script pour créer des badges par défaut dans Directus
# Usage: ./create-default-badges.sh

DIRECTUS_URL="http://localhost:8055"

echo "🏷️  Création des badges par défaut..."

# Liste des badges à créer
badges=(
  "Santé bucco-dentaire"
  "Prévention"
  "Soins dentaires"
  "Orthodontie"
  "Implants"
  "Esthétique dentaire"
  "Hygiène"
  "Conseils"
)

# Créer chaque badge
for badge_name in "${badges[@]}"; do
  echo "Création du badge: $badge_name"
  
  curl -X POST "$DIRECTUS_URL/items/badges" \
    -H "Content-Type: application/json" \
    -d "{
      \"nom\": \"$badge_name\",
      \"status\": \"published\"
    }"
  
  echo ""
done

echo "✅ Badges créés avec succès!"
echo ""
echo "Vous pouvez maintenant:"
echo "1. Aller dans Directus (http://localhost:8055)"
echo "2. Éditer un article de blog"
echo "3. Sélectionner un ou plusieurs badges"
echo "4. Ajouter un temps de lecture (en minutes)"
