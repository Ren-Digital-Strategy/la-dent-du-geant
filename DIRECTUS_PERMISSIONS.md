# Configuration des Permissions Directus pour le Blog

## ⚠️ IMPORTANT : Configuration des permissions publiques

Pour que les articles de blog soient accessibles via l'API publique (sans authentification), vous devez configurer les permissions pour le rôle "Public".

## Étapes de configuration

### 1. Accéder aux paramètres de permissions

1. Connectez-vous à Directus : http://localhost:8055
2. Allez dans **Settings** (⚙️) dans la barre latérale
3. Cliquez sur **Access Control**
4. Sélectionnez le rôle **Public**

### 2. Configurer les permissions pour la collection "blog"

1. Dans la liste des collections, trouvez **blog**
2. Cliquez sur l'icône de permissions (🔒)
3. Activez la permission **Read** (lecture)
4. Dans les options de la permission Read :
   - **Item Permissions** : Laissez vide (tous les items)
   - **Field Permissions** : Sélectionnez tous les champs ou laissez "*" pour tous
   - **Field Validation** : Aucune validation nécessaire pour la lecture
5. Cliquez sur **Save**

### 3. Configurer les permissions pour "directus_files"

1. Dans la liste des collections, trouvez **directus_files**
2. Cliquez sur l'icône de permissions (🔒)
3. Activez la permission **Read** (lecture)
4. Cliquez sur **Save**

### 4. Vérifier la configuration

Testez l'API publique avec cette URL dans votre navigateur :

```
http://localhost:8055/items/blog?filter[status][_eq]=published
```

Vous devriez voir une réponse JSON avec les articles publiés.

## Configuration alternative via l'API

Si vous préférez configurer les permissions via l'API, vous pouvez utiliser ces requêtes :

### Obtenir l'ID de la politique publique

```bash
curl http://localhost:8055/policies
```

### Ajouter les permissions

```bash
# Permission pour la collection blog
curl -X POST http://localhost:8055/permissions \
  -H "Content-Type: application/json" \
  -d '{
    "policy": "PUBLIC_POLICY_ID",
    "collection": "blog",
    "action": "read",
    "permissions": {},
    "fields": ["*"]
  }'

# Permission pour directus_files
curl -X POST http://localhost:8055/permissions \
  -H "Content-Type: application/json" \
  -d '{
    "policy": "PUBLIC_POLICY_ID",
    "collection": "directus_files",
    "action": "read",
    "permissions": {},
    "fields": ["*"]
  }'
```

## Filtres de permissions avancés

Si vous souhaitez restreindre l'accès public uniquement aux articles publiés :

1. Dans les permissions de la collection "blog"
2. Ajoutez un filtre dans **Item Permissions** :

```json
{
  "status": {
    "_eq": "published"
  }
}
```

Cela garantit que seuls les articles avec le statut "published" sont accessibles publiquement.

## Dépannage

### Erreur 403 Forbidden

Si vous obtenez une erreur 403 lors de l'accès à l'API :
- Vérifiez que les permissions Read sont bien activées pour le rôle Public
- Vérifiez que la collection "blog" et "directus_files" ont les bonnes permissions
- Redémarrez le conteneur Directus si nécessaire

### Les images ne s'affichent pas

Si les images ne s'affichent pas sur le site :
- Vérifiez que "directus_files" a la permission Read pour le rôle Public
- Vérifiez que les URLs des images sont correctes : `http://localhost:8055/assets/{file_id}`
- Vérifiez les CORS si vous accédez depuis un autre domaine

## CORS (Cross-Origin Resource Sharing)

Si vous accédez à Directus depuis un domaine différent, vous devrez peut-être configurer CORS :

Ajoutez dans votre `docker-compose.dev.yml` :

```yaml
environment:
  CORS_ENABLED: "true"
  CORS_ORIGIN: "http://localhost:4321"
```

Puis redémarrez les conteneurs :

```bash
docker-compose -f docker-compose.dev.yml down
docker-compose -f docker-compose.dev.yml up
```
