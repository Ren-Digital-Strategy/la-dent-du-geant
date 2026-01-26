# Configuration du Blog - La Dent du Géant

## ✅ Configuration terminée

Tout a été configuré avec succès ! Voici un récapitulatif complet.

## Collection Blog créée avec succès ✅

La collection `blog` a été créée dans Directus avec les champs suivants :

### Champs de la collection

1. **titre** (string, requis) - Titre de l'article
2. **description** (text, requis) - Courte description de l'article
3. **contenu** (WYSIWYG HTML, requis) - Contenu principal de l'article
4. **auteur_nom** (string, requis) - Nom de l'auteur
5. **auteur_profession** (string, requis) - Profession de l'auteur
6. **photo_principale** (image, requis) - Image principale de l'article
7. **avatar_auteur** (image, requis) - Photo de profil de l'auteur
8. **status** (draft/published/archived) - Statut de publication
9. **date_created** - Date de création automatique
10. **date_updated** - Date de mise à jour automatique

## Comment ajouter un article de blog

1. Accédez à Directus : http://localhost:8055
2. Connectez-vous avec les identifiants :
   - Email: admin@example.com
   - Mot de passe: admin
3. Allez dans la collection "Blog"
4. Cliquez sur "Create Item"
5. Remplissez tous les champs requis :
   - Uploadez une photo principale
   - Uploadez un avatar pour l'auteur
   - Ajoutez le titre, description et contenu
   - Renseignez le nom et la profession de l'auteur
6. Changez le statut à "Published" pour que l'article soit visible
7. Cliquez sur "Save"

## Intégration API

Le composant `BlogSection.astro` récupère automatiquement les articles publiés depuis Directus via l'API REST :

```
GET http://localhost:8055/items/blog?filter[status][_eq]=published
```

### Variables d'environnement

La variable `DIRECTUS_URL` est configurée dans le fichier `docker-compose.dev.yml` :

```yaml
environment:
  - DIRECTUS_URL=http://directus:8055
```

Pour le développement local (sans Docker), créez un fichier `.env` :

```
DIRECTUS_URL=http://localhost:8055
```

## Affichage sur le site

Les articles de blog s'affichent sur la page `/blog` avec :
- Une grille responsive (1 colonne mobile, 2 tablette, 3 desktop)
- L'image principale en haut
- Le titre et la description
- Les informations de l'auteur (avatar, nom, profession)
- La date de publication formatée en français

## Permissions Directus

Pour que l'API publique fonctionne, assurez-vous que :
1. Le rôle "Public" a les permissions de lecture sur la collection "blog"
2. Le rôle "Public" a les permissions de lecture sur "directus_files"

### Configuration des permissions

1. Allez dans Settings > Access Control > Public
2. Ajoutez les permissions :
   - Collection: blog - Action: Read
   - Collection: directus_files - Action: Read

## Démarrage du projet

```bash
# Avec Docker
docker-compose -f docker-compose.dev.yml up

# Le site sera accessible sur http://localhost:4321
# Directus sera accessible sur http://localhost:8055
```

## Structure des fichiers

- `/src/components/blog/BlogSection.astro` - Composant d'affichage des articles (liste)
- `/src/components/blog/HeroBlog.astro` - Hero de la page blog
- `/src/pages/blog.astro` - Page blog principale (liste des articles)
- `/src/pages/blog/[id].astro` - Page de détail d'un article
- `/BLOG_SETUP.md` - Ce fichier (guide de configuration)
- `/DIRECTUS_PERMISSIONS.md` - Guide détaillé pour configurer les permissions

## Fonctionnalités implémentées

### Page liste des articles (`/blog`)
- ✅ Affichage en grille responsive (1/2/3 colonnes)
- ✅ Image principale de chaque article
- ✅ Titre et description
- ✅ Informations auteur (avatar, nom, profession)
- ✅ Date de publication formatée en français
- ✅ Lien vers la page de détail
- ✅ Effet hover sur les cartes
- ✅ Message si aucun article disponible

### Page détail d'un article (`/blog/[id]`)
- ✅ Image principale en grand format
- ✅ Titre et description
- ✅ Informations auteur avec avatar
- ✅ Date de publication
- ✅ Contenu HTML complet (WYSIWYG)
- ✅ Styles personnalisés pour le contenu (prose)
- ✅ Bouton retour vers la liste
- ✅ Redirection 404 si article non trouvé ou non publié

### API Directus
- ✅ Collection `blog` créée avec tous les champs
- ✅ Relations configurées pour les images
- ✅ Champs système (user_created, date_created, etc.)
- ✅ Statut de publication (draft/published/archived)
- ✅ Tri par date décroissante

## Prochaines étapes

### 1. Configurer les permissions (IMPORTANT !)

Consultez le fichier `DIRECTUS_PERMISSIONS.md` pour configurer l'accès public à l'API.

**Résumé rapide :**
1. Allez dans Settings > Access Control > Public
2. Activez la permission Read pour "blog"
3. Activez la permission Read pour "directus_files"

### 2. Créer votre premier article

1. Connectez-vous à Directus
2. Allez dans la collection "Blog"
3. Créez un nouvel article avec tous les champs
4. Changez le statut à "Published"
5. Sauvegardez

### 3. Tester l'affichage

1. Démarrez le projet : `docker-compose -f docker-compose.dev.yml up`
2. Accédez à http://localhost:4321/blog
3. Vérifiez que votre article s'affiche
4. Cliquez sur l'article pour voir la page de détail

## Améliorations possibles

- Ajouter une pagination pour gérer de nombreux articles
- Ajouter un système de catégories/tags
- Ajouter une recherche d'articles
- Ajouter un système de commentaires
- Ajouter le partage sur les réseaux sociaux
- Ajouter des articles similaires/recommandés
- Ajouter un temps de lecture estimé
- Optimiser les images (lazy loading, formats modernes)
- Ajouter un sitemap pour le SEO
- Ajouter les meta tags Open Graph pour les réseaux sociaux
