# 📡 Documentation API Blog - Directus

## URL de base

- **Développement** : `http://localhost:8055`
- **Production** : À configurer selon votre déploiement

## Endpoints

### 1. Liste des articles publiés

```http
GET /items/blog?filter[status][_eq]=published&sort=-date_created
```

**Paramètres de requête :**

| Paramètre | Description | Exemple |
|-----------|-------------|---------|
| `filter[status][_eq]` | Filtrer par statut | `published` |
| `sort` | Tri des résultats | `-date_created` (décroissant) |
| `fields` | Champs à retourner | `id,titre,description` |
| `limit` | Nombre de résultats | `10` |
| `offset` | Pagination | `0` |

**Exemple complet :**

```http
GET /items/blog?filter[status][_eq]=published&fields=id,titre,description,photo_principale.id&sort=-date_created&limit=10
```

**Réponse :**

```json
{
  "data": [
    {
      "id": "uuid-123",
      "titre": "Mon article",
      "description": "Description courte",
      "photo_principale": {
        "id": "file-uuid-456"
      },
      "date_created": "2024-01-15T10:30:00Z"
    }
  ]
}
```

### 2. Détail d'un article

```http
GET /items/blog/{id}
```

**Paramètres :**

| Paramètre | Type | Description |
|-----------|------|-------------|
| `id` | UUID | Identifiant de l'article |

**Exemple :**

```http
GET /items/blog/abc-123-def-456?fields=*,photo_principale.*,avatar_auteur.*
```

**Réponse :**

```json
{
  "data": {
    "id": "abc-123-def-456",
    "titre": "Comment les nouvelles technologies dentaires révolutionnent votre sourire",
    "description": "De la conception numérique aux traitements esthétiques...",
    "contenu": "<h2>L'ère du numérique...</h2>",
    "auteur_nom": "Julien Van de Velde",
    "auteur_profession": "Dentiste généraliste",
    "photo_principale": {
      "id": "photo-uuid",
      "filename_disk": "abc123.jpg",
      "type": "image/jpeg",
      "width": 1920,
      "height": 1080
    },
    "avatar_auteur": {
      "id": "avatar-uuid",
      "filename_disk": "def456.jpg",
      "type": "image/jpeg"
    },
    "status": "published",
    "date_created": "2024-01-15T10:30:00Z",
    "date_updated": "2024-01-15T14:20:00Z"
  }
}
```

### 3. Récupération d'images

```http
GET /assets/{file_id}
```

**Paramètres de transformation (optionnels) :**

| Paramètre | Description | Exemple |
|-----------|-------------|---------|
| `width` | Largeur en pixels | `?width=800` |
| `height` | Hauteur en pixels | `?height=600` |
| `fit` | Mode de redimensionnement | `?fit=cover` |
| `quality` | Qualité (1-100) | `?quality=80` |
| `format` | Format de sortie | `?format=webp` |

**Exemples :**

```http
# Image originale
GET /assets/abc-123-def-456

# Image redimensionnée
GET /assets/abc-123-def-456?width=800&height=600&fit=cover

# Image optimisée en WebP
GET /assets/abc-123-def-456?width=1200&quality=85&format=webp
```

## Filtres avancés

### Recherche par texte

```http
GET /items/blog?search=dentaire
```

### Filtres multiples

```http
GET /items/blog?filter[status][_eq]=published&filter[auteur_nom][_contains]=Julien
```

### Tri

```http
# Par date décroissante (plus récent d'abord)
GET /items/blog?sort=-date_created

# Par titre alphabétique
GET /items/blog?sort=titre

# Tri multiple
GET /items/blog?sort=-date_created,titre
```

### Pagination

```http
# Page 1 (10 premiers articles)
GET /items/blog?limit=10&offset=0

# Page 2 (articles 11-20)
GET /items/blog?limit=10&offset=10

# Page 3 (articles 21-30)
GET /items/blog?limit=10&offset=20
```

## Sélection de champs

### Champs simples

```http
GET /items/blog?fields=id,titre,description
```

### Champs relationnels

```http
# Récupérer l'ID de l'image
GET /items/blog?fields=titre,photo_principale.id

# Récupérer toutes les infos de l'image
GET /items/blog?fields=titre,photo_principale.*

# Récupérer des champs spécifiques de l'image
GET /items/blog?fields=titre,photo_principale.id,photo_principale.filename_disk,photo_principale.width
```

## Exemples d'utilisation

### JavaScript / Fetch

```javascript
// Liste des articles
async function getArticles() {
  const response = await fetch(
    'http://localhost:8055/items/blog?filter[status][_eq]=published&sort=-date_created'
  );
  const data = await response.json();
  return data.data;
}

// Détail d'un article
async function getArticle(id) {
  const response = await fetch(
    `http://localhost:8055/items/blog/${id}?fields=*,photo_principale.*,avatar_auteur.*`
  );
  const data = await response.json();
  return data.data;
}
```

### Astro (SSR)

```astro
---
const DIRECTUS_URL = import.meta.env.DIRECTUS_URL || 'http://localhost:8055';

// Liste des articles
const articlesResponse = await fetch(
  `${DIRECTUS_URL}/items/blog?filter[status][_eq]=published&sort=-date_created`
);
const articlesData = await articlesResponse.json();
const articles = articlesData.data;

// Détail d'un article
const { id } = Astro.params;
const articleResponse = await fetch(
  `${DIRECTUS_URL}/items/blog/${id}?fields=*,photo_principale.*,avatar_auteur.*`
);
const articleData = await articleResponse.json();
const article = articleData.data;
---
```

### cURL

```bash
# Liste des articles
curl "http://localhost:8055/items/blog?filter[status][_eq]=published"

# Détail d'un article
curl "http://localhost:8055/items/blog/abc-123-def-456"

# Avec authentification (si nécessaire)
curl -H "Authorization: Bearer YOUR_TOKEN" \
  "http://localhost:8055/items/blog"
```

## Gestion des erreurs

### 404 - Article non trouvé

```json
{
  "errors": [
    {
      "message": "Item not found",
      "extensions": {
        "code": "RECORD_NOT_FOUND"
      }
    }
  ]
}
```

### 403 - Accès refusé

```json
{
  "errors": [
    {
      "message": "You don't have permission to access this.",
      "extensions": {
        "code": "FORBIDDEN"
      }
    }
  ]
}
```

**Solution** : Vérifiez les permissions du rôle Public (voir `DIRECTUS_PERMISSIONS.md`)

## Performance et optimisation

### 1. Limiter les champs retournés

```http
# ❌ Mauvais - récupère tout
GET /items/blog

# ✅ Bon - seulement les champs nécessaires
GET /items/blog?fields=id,titre,description,photo_principale.id
```

### 2. Utiliser la pagination

```http
# ✅ Bon - limite le nombre de résultats
GET /items/blog?limit=10&offset=0
```

### 3. Optimiser les images

```http
# ✅ Bon - image redimensionnée et optimisée
GET /assets/{id}?width=800&quality=85&format=webp
```

### 4. Mettre en cache

Utilisez les en-têtes HTTP de cache pour améliorer les performances :

```javascript
const response = await fetch(url, {
  headers: {
    'Cache-Control': 'public, max-age=3600'
  }
});
```

## Webhooks (optionnel)

Pour être notifié lors de la création/modification d'articles, configurez un webhook dans Directus :

1. Settings → Webhooks
2. Créez un nouveau webhook
3. URL : `https://votre-site.com/api/webhook`
4. Actions : `items.create`, `items.update`
5. Collections : `blog`

## Ressources

- [Documentation Directus API](https://docs.directus.io/reference/introduction.html)
- [Filtres Directus](https://docs.directus.io/reference/filter-rules.html)
- [Transformation d'images](https://docs.directus.io/reference/files.html#requesting-a-thumbnail)
