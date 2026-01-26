# ✅ Checklist de configuration du Blog

Utilisez cette checklist pour vérifier que tout est correctement configuré.

## 1. Collection Directus

- [ ] La collection `blog` existe dans Directus
- [ ] Tous les champs sont présents (titre, description, contenu, etc.)
- [ ] Les relations avec `directus_files` sont configurées
- [ ] Les champs système (user_created, date_created) sont présents

**Comment vérifier :**
1. Allez sur http://localhost:8055/admin
2. Connectez-vous (admin@example.com / admin)
3. Vérifiez que "Blog" apparaît dans le menu latéral

## 2. Permissions publiques

- [ ] Le rôle "Public" a la permission Read sur `blog`
- [ ] Le rôle "Public" a la permission Read sur `directus_files`

**Comment configurer :**
1. Settings → Access Control → Public
2. Activez Read pour `blog`
3. Activez Read pour `directus_files`

**Comment tester :**
```bash
# Cette commande doit retourner un JSON (pas d'erreur 403)
curl http://localhost:8055/items/blog
```

## 3. Variables d'environnement

- [ ] `DIRECTUS_URL` est configurée dans `docker-compose.dev.yml`
- [ ] La variable pointe vers `http://directus:8055` (pour Docker)

**Comment vérifier :**
```bash
# Vérifiez le fichier docker-compose.dev.yml
grep DIRECTUS_URL docker-compose.dev.yml
```

## 4. Fichiers du projet

- [ ] `/src/components/blog/BlogSection.astro` existe
- [ ] `/src/components/blog/HeroBlog.astro` existe
- [ ] `/src/pages/blog.astro` importe BlogSection
- [ ] `/src/pages/blog/[id].astro` existe
- [ ] `/src/styles/global.css` contient les styles `.blog-content`

**Comment vérifier :**
```bash
ls -la src/components/blog/
ls -la src/pages/blog/
```

## 5. Premier article de test

- [ ] Au moins un article existe dans Directus
- [ ] L'article a une photo principale uploadée
- [ ] L'article a un avatar d'auteur uploadé
- [ ] Tous les champs requis sont remplis
- [ ] Le statut de l'article est "Published"

**Comment créer :**
1. Dans Directus, allez dans "Blog"
2. Cliquez sur "Create Item"
3. Remplissez tous les champs
4. Uploadez les images
5. Changez le statut à "Published"
6. Sauvegardez

## 6. Test de l'affichage

- [ ] Le projet démarre sans erreur
- [ ] La page `/blog` s'affiche
- [ ] Les articles apparaissent sur `/blog`
- [ ] Les images s'affichent correctement
- [ ] Le clic sur un article mène à la page de détail
- [ ] La page de détail affiche tout le contenu
- [ ] Le bouton "Retour au blog" fonctionne

**Comment tester :**
```bash
# Démarrer le projet
docker-compose -f docker-compose.dev.yml up

# Puis visitez :
# - http://localhost:4321/blog
# - http://localhost:4321/blog/{id-de-votre-article}
```

## 7. Vérifications visuelles

Sur la page `/blog` :
- [ ] Les cartes d'articles s'affichent en grille
- [ ] Les images principales sont visibles
- [ ] Les titres et descriptions sont lisibles
- [ ] Les avatars des auteurs s'affichent
- [ ] Les dates sont formatées en français
- [ ] L'effet hover fonctionne sur les cartes

Sur la page `/blog/[id]` :
- [ ] L'image principale est en grand format
- [ ] Le titre et la description sont visibles
- [ ] Les informations de l'auteur s'affichent
- [ ] Le contenu HTML est bien formaté
- [ ] Les styles du contenu sont appliqués
- [ ] Le bouton retour est présent

## 8. Tests de responsive

- [ ] La grille s'adapte sur mobile (1 colonne)
- [ ] La grille s'adapte sur tablette (2 colonnes)
- [ ] La grille s'adapte sur desktop (3 colonnes)
- [ ] Les images se redimensionnent correctement
- [ ] Le texte reste lisible sur tous les écrans

**Comment tester :**
Utilisez les outils de développement du navigateur pour tester différentes tailles d'écran.

## 9. Performance

- [ ] Les images se chargent rapidement
- [ ] Pas d'erreurs dans la console du navigateur
- [ ] Pas d'erreurs dans les logs du serveur
- [ ] L'API répond rapidement (< 1 seconde)

**Comment vérifier :**
```bash
# Vérifier les logs Docker
docker-compose -f docker-compose.dev.yml logs -f

# Ouvrir la console du navigateur (F12)
# Vérifier l'onglet Network pour les temps de chargement
```

## 10. Documentation

- [ ] `RESUME_BLOG.md` est présent et à jour
- [ ] `BLOG_SETUP.md` est présent
- [ ] `DIRECTUS_PERMISSIONS.md` est présent
- [ ] `API_DOCUMENTATION.md` est présent
- [ ] `CHECKLIST.md` (ce fichier) est présent

## Dépannage

### ❌ Les articles ne s'affichent pas

**Causes possibles :**
1. Les permissions ne sont pas configurées → Voir section 2
2. Aucun article n'est publié → Voir section 5
3. Erreur de connexion à Directus → Vérifier les logs Docker

**Solution :**
```bash
# Vérifier que Directus est accessible
curl http://localhost:8055/server/health

# Vérifier l'API des articles
curl http://localhost:8055/items/blog
```

### ❌ Les images ne s'affichent pas

**Causes possibles :**
1. Permissions manquantes sur `directus_files`
2. Images non uploadées
3. URL incorrecte

**Solution :**
```bash
# Vérifier l'accès aux fichiers
curl http://localhost:8055/files

# Tester une URL d'image
curl -I http://localhost:8055/assets/{file-id}
```

### ❌ Erreur 404 sur la page de détail

**Causes possibles :**
1. L'article n'existe pas
2. L'article n'est pas publié
3. L'ID est incorrect

**Solution :**
Vérifiez l'ID de l'article dans Directus et assurez-vous qu'il est publié.

### ❌ Le contenu HTML n'est pas formaté

**Causes possibles :**
1. Les styles `.blog-content` ne sont pas appliqués
2. Le fichier `global.css` n'est pas importé

**Solution :**
Vérifiez que `global.css` contient les styles et est importé dans `Layout.astro`.

## Prochaines étapes

Une fois que tout est coché :

1. 🎨 Personnalisez le design selon vos besoins
2. 📝 Créez plusieurs articles de test
3. 🚀 Testez en profondeur
4. 📱 Vérifiez sur différents appareils
5. 🌐 Préparez le déploiement en production

## Support

Si vous rencontrez des problèmes :

1. Consultez les fichiers de documentation
2. Vérifiez les logs Docker : `docker-compose logs`
3. Vérifiez la console du navigateur (F12)
4. Testez les endpoints API avec curl ou Postman

---

**Une fois tout coché, votre blog est prêt ! 🎉**
