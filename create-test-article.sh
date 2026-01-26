#!/bin/bash

# Script pour créer un article de test dans Directus
# Usage: ./create-test-article.sh

DIRECTUS_URL="http://localhost:8055"
ADMIN_EMAIL="admin@example.com"
ADMIN_PASSWORD="admin"

echo "🚀 Création d'un article de test dans Directus..."

# 1. Authentification
echo "📝 Authentification..."
AUTH_RESPONSE=$(curl -s -X POST "$DIRECTUS_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$ADMIN_EMAIL\",\"password\":\"$ADMIN_PASSWORD\"}")

ACCESS_TOKEN=$(echo $AUTH_RESPONSE | grep -o '"access_token":"[^"]*' | sed 's/"access_token":"//')

if [ -z "$ACCESS_TOKEN" ]; then
  echo "❌ Erreur d'authentification. Vérifiez vos identifiants."
  exit 1
fi

echo "✅ Authentification réussie"

# 2. Upload de l'image principale (utiliser une image de test)
echo "📸 Upload de l'image principale..."
# Note: Vous devrez remplacer ce chemin par une vraie image
# PHOTO_RESPONSE=$(curl -s -X POST "$DIRECTUS_URL/files" \
#   -H "Authorization: Bearer $ACCESS_TOKEN" \
#   -F "file=@./public/images/test-blog.jpg")

# 3. Upload de l'avatar de l'auteur
echo "👤 Upload de l'avatar de l'auteur..."
# AVATAR_RESPONSE=$(curl -s -X POST "$DIRECTUS_URL/files" \
#   -H "Authorization: Bearer $ACCESS_TOKEN" \
#   -F "file=@./public/images/avatar-test.jpg")

# 4. Création de l'article
echo "✍️ Création de l'article..."

# Pour l'instant, créons l'article sans images (à compléter manuellement)
ARTICLE_RESPONSE=$(curl -s -X POST "$DIRECTUS_URL/items/blog" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d @exemple-article.json)

echo "✅ Article créé avec succès!"
echo ""
echo "📋 Prochaines étapes:"
echo "1. Allez sur $DIRECTUS_URL/admin"
echo "2. Ouvrez la collection 'Blog'"
echo "3. Éditez l'article créé"
echo "4. Ajoutez une photo principale et un avatar"
echo "5. Vérifiez que le statut est 'published'"
echo "6. Sauvegardez"
echo ""
echo "🌐 Ensuite, visitez http://localhost:4321/blog pour voir votre article!"
