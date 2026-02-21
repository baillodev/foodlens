# FoodLens

Analyse nutritionnelle intelligente par vision par ordinateur.

Prenez une photo de votre repas et obtenez instantanement les informations nutritionnelles : calories, proteines, glucides et lipides.

## Stack technique

- **Backend** : FastAPI (Python) - API REST, orchestration IA, base de donnees
- **Frontend** : Flutter (Dart) - Application mobile multiplateforme
- **IA** : Spoonacular API (reconnaissance alimentaire + nutrition)
- **Stockage images** : Cloudinary

## Architecture

```
Flutter App  -->  FastAPI  -->  Cloudinary (upload image)
                    |
                    +-------->  Spoonacular (analyse IA + nutrition)
                    |
                    +-------->  SQLite (historique)
```

## Prerequis

- Python 3.11+
- Flutter 3.x+
- Compte Cloudinary (gratuit)
- Cle API Spoonacular (plan gratuit sur spoonacular.com)

## Installation

### Backend

```bash
cd backend
python -m venv .venv
source .venv/bin/activate  # Linux/Mac
pip install -r requirements.txt
cp .env.example .env       # Remplir avec vos cles API
uvicorn main:app --reload
```

Le serveur demarre sur `http://localhost:8000`. Documentation Swagger disponible sur `/docs`.

### Frontend

```bash
cd frontend
flutter pub get
flutter run
```

## Configuration

Copier `backend/.env.example` vers `backend/.env` et remplir les variables :

```
SPOONACULAR_API_KEY=votre_cle_spoonacular
CLOUDINARY_CLOUD_NAME=votre_cloud_name
CLOUDINARY_API_KEY=votre_api_key
CLOUDINARY_API_SECRET=votre_api_secret
```

## Endpoints API

| Methode | Endpoint | Description |
|---------|----------|-------------|
| `POST` | `/api/v1/analyze` | Analyse nutritionnelle d'une image |
| `GET` | `/api/v1/health` | Health check |
| `GET` | `/api/v1/history` | Liste des analyses passees |
| `GET` | `/api/v1/history/{id}` | Detail d'une analyse |

## Licence

MIT - voir [LICENSE](LICENSE)
