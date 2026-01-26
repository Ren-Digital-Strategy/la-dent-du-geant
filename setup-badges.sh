#!/bin/bash

TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImIxNzdmYmUwLWEyZjMtNGZhNS05ZDM2LTcxNTQ3OTVlMzA0OSIsInJvbGUiOiJiZjhkZTRhNy02MzNhLTRhMzAtOTA2OS04MzY4M2RiMWRiNmEiLCJhcHBfYWNjZXNzIjp0cnVlLCJhZG1pbl9hY2Nlc3MiOnRydWUsImlhdCI6MTc2OTQzMTE3MywiZXhwIjoxNzY5NDMyMDczLCJpc3MiOiJkaXJlY3R1cyJ9.I_UFPH3MsfL1vO6MYDrZPAQ2S_SlGcbHmm-CU0A32Q0"

echo "Création de la collection badges..."

# Créer la collection badges
curl -X POST "http://localhost:8055/collections" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "collection": "badges",
    "meta": {
      "icon": "label",
      "note": "Badges pour catégoriser les articles de blog",
      "display_template": "{{nom}}",
      "color": "#A78BFA"
    },
    "schema": {},
    "fields": [
      {
        "field": "id",
        "type": "uuid",
        "schema": {
          "is_primary_key": true
        },
        "meta": {
          "hidden": true,
          "readonly": true,
          "special": ["uuid"]
        }
      },
      {
        "field": "nom",
        "type": "string",
        "schema": {
          "is_nullable": false
        },
        "meta": {
          "interface": "input",
          "required": true,
          "note": "Nom du badge"
        }
      },
      {
        "field": "couleur",
        "type": "string",
        "schema": {
          "default_value": "#414651"
        },
        "meta": {
          "interface": "select-color",
          "note": "Couleur du badge"
        }
      }
    ]
  }'

echo ""
echo "✅ Collection badges créée"
