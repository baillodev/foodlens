# Architecture technique - FoodLens

## Vue d'ensemble

FoodLens suit une architecture client-serveur avec integration d'un service IA externe.

```
┌─────────────────────────────────────────────────────────────┐
│                    Pipeline FoodLens                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Flutter App   -->   FastAPI      -->   Spoonacular API     │
│  (Capture)          (Orchestration)     (Reconnaissance +   │
│                                          Nutrition)         │
│  Resultats    <--   FastAPI      <--   Nutrition Data       │
│  (Affichage)        (Structuration)    (Calories, macros)   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Flux de donnees

1. **Capture** : L'utilisateur prend une photo ou selectionne une image depuis la galerie (Flutter)
2. **Envoi** : L'image est envoyee au backend via POST multipart/form-data
3. **Hebergement** : Le backend upload l'image sur Cloudinary pour obtenir une URL publique
4. **Analyse IA** : FastAPI appelle l'API Spoonacular avec l'URL de l'image
5. **Structuration** : Le backend transforme la reponse IA, calcule les totaux nutritionnels et sauvegarde en base
6. **Restitution** : Les resultats sont renvoyes au frontend et affiches

## Structure backend (FastAPI)

```
backend/
├── main.py              # Point d'entree, configuration CORS, inclusion des routers
├── config.py            # Variables d'environnement (pydantic-settings)
├── database.py          # Initialisation SQLite, creation des tables
├── models.py            # Schemas Pydantic (validation entree/sortie)
├── routers/
│   ├── analyze.py       # POST /api/v1/analyze - endpoint principal
│   ├── health.py        # GET /api/v1/health
│   └── history.py       # GET /api/v1/history, /api/v1/history/{id}
└── services/
    ├── cloudinary_service.py   # Upload d'image vers Cloudinary
    ├── spoonacular_service.py  # Appel a l'API Spoonacular (reconnaissance + nutrition)
    └── history_service.py      # Operations CRUD SQLite
```

### Base de donnees (SQLite)

Deux tables :
- **analyses** : id, image_url, is_food, raw_response (JSON), analyzed_at
- **food_items** : id, analysis_id (FK), name, group, confidence_score, calories, protein, total_carbs, total_fat, serving_weight, serving_unit

### Securite

- Les cles API (Spoonacular, Cloudinary) sont stockees exclusivement cote serveur dans `.env`
- Validation stricte des fichiers uploades (type MIME, taille max)
- CORS configure pour autoriser le frontend

## Structure frontend (Flutter)

```
frontend/lib/
├── main.dart            # MultiProvider, MaterialApp, routes
├── config/
│   ├── api_config.dart  # URL du backend
│   └── theme.dart       # Theme visuel de l'application
├── models/              # Classes Dart miroir des schemas backend
├── providers/           # Gestion d'etat avec Provider (ChangeNotifier)
├── services/
│   └── api_service.dart # Communication HTTP avec le backend
├── screens/             # Ecrans de l'application
└── widgets/             # Composants reutilisables
```

### Navigation

```
HomeScreen  --[Analyser]--> CaptureScreen --> LoadingScreen --> ResultsScreen
HomeScreen  --[Historique]--> HistoryScreen --> ResultsScreen (detail)
```

### Gestion d'etat

- **AnalysisProvider** : gere le cycle de vie d'une analyse (loading, result, error)
- **HistoryProvider** : gere la liste des analyses passees

## Choix techniques

| Decision | Justification |
|----------|---------------|
| aiosqlite (pas SQLAlchemy) | Projet simple, 2 tables, pas besoin d'ORM complexe |
| Cloudinary (pas Firebase Storage) | SDK Python simple, free tier genereux, integration directe |
| Provider (pas Riverpod) | Plus simple a mettre en place, adapte a la taille du projet |
| httpx (pas requests) | Support natif async, compatible avec FastAPI |
