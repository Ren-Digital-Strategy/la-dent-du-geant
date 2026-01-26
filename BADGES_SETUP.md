# Configuration des Badges et Temps de Lecture

## 📋 Vue d'ensemble

Ce document décrit la configuration des badges et du temps de lecture pour les articles de blog.

## 🗄️ Structure de la base de données

### Collection `badges`

Nouvelle collection pour gérer les catégories/badges des articles.

**Champs :**
- `id` (UUID) - Identifiant unique
- `nom` (string) - Nom du badge (ex: "Santé bucco-dentaire", "Prévention")
- `status` (string) - Statut (draft/published/archived)
- `sort` (integer) - Ordre de tri
- `date_created` (timestamp) - Date de création
- `date_updated` (timestamp) - Date de modification
- `blogs` (O2M) - Articles associés à ce badge

**URL Directus :** http://localhost:8055/admin/content/badges

### Collection `blog` (modifications)

**Nouveaux champs :**
- `temps_lecture` (integer) - Temps de lecture estimé en minutes
- `badges` (M2M) - Relation many-to-many avec la collection badges

### Collection `blog_badges` (jonction)

Table de jonction pour la relation M2M entre blog et badges.

**Champs :**
- `id` (UUID) - Identifiant unique
- `blog_id` (UUID) - Référence à l'article
- `badges_id` (UUID) - Référence au badge
- `sort` (integer) - Ordre des badges pour un article

## 🎨 Affichage Frontend

### BlogSection.astro

Affiche le premier badge et le temps de lecture dans les cartes d'aperçu des articles :

```astro
{article.badges && article.badges.length > 0 && (
  <div class="bg-[#fafafa] border border-[#e9eaeb] px-2 py-0.5 rounded-full">
    <span class="text-xs font-medium text-[#414651]">
      {article.badges[0].badges_id.nom}
    </span>
  </div>
)}
{article.temps_lecture && (
  <span class="text-xs font-medium text-[#3c3c3c]">
    Temps de lecture : {article.temps_lecture} min
  </span>
)}
```

### [id].astro

Affiche tous les badges et le temps de lecture dans la page détaillée de l'article :

```astro
{article.badges && article.badges.map((badge) => (
  <span class="bg-[#fafafa] border border-[#e9eaeb] px-3 py-1 rounded-full">
    {badge.badges_id.nom}
  </span>
))}
{article.temps_lecture && (
  <span>⏱️ Temps de lecture : {article.temps_lecture} min</span>
)}
```

## 🚀 Utilisation

### 1. Créer des badges par défaut

Exécutez le script pour créer des badges prédéfinis :

```bash
./create-default-badges.sh
```

Ce script crée les badges suivants :
- Santé bucco-dentaire
- Prévention
- Soins dentaires
- Orthodontie
- Implants
- Esthétique dentaire
- Hygiène
- Conseils

### 2. Ajouter des badges à un article

1. Allez dans Directus : http://localhost:8055
2. Ouvrez la collection "Blog"
3. Éditez un article existant ou créez-en un nouveau
4. Dans le champ "Badges" :
   - **Sélectionner un badge existant** : Cliquez sur "+" puis sélectionnez dans la liste
   - **Créer un nouveau badge** : Cliquez sur "+" puis "Create New" et remplissez le nom
5. Ajoutez le temps de lecture (en minutes) dans le champ "Temps lecture"
6. Sauvegardez l'article

### 3. Gérer les badges

Pour gérer tous les badges :

1. Allez dans Directus : http://localhost:8055/admin/content/badges
2. Vous pouvez :
   - Créer de nouveaux badges
   - Modifier les badges existants
   - Voir quels articles utilisent chaque badge
   - Archiver les badges inutilisés

## 🔄 API Directus

### Récupérer les articles avec badges

```javascript
const response = await fetch(
  `${DIRECTUS_URL}/items/blog?fields=id,titre,description,temps_lecture,badges.badges_id.id,badges.badges_id.nom`
);
```

### Créer un article avec badges

```javascript
const response = await fetch(`${DIRECTUS_URL}/items/blog`, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    titre: "Mon article",
    description: "Description",
    contenu: "Contenu HTML",
    temps_lecture: 5,
    badges: [
      { badges_id: "uuid-du-badge-1" },
      { badges_id: "uuid-du-badge-2" }
    ]
  })
});
```

## 💡 Avantages

1. **Flexibilité** : Possibilité d'ajouter plusieurs badges par article
2. **Création rapide** : Créer de nouveaux badges directement depuis l'édition d'un article
3. **Réutilisabilité** : Les badges peuvent être réutilisés sur plusieurs articles
4. **Organisation** : Facilite la catégorisation et le filtrage des articles
5. **UX améliorée** : Les utilisateurs voient immédiatement le sujet et la durée de lecture

## 🎯 Prochaines étapes possibles

- Ajouter un filtre par badge sur la page blog
- Créer une page dédiée pour chaque badge listant tous les articles associés
- Ajouter des couleurs personnalisées pour chaque badge
- Calculer automatiquement le temps de lecture basé sur le contenu
