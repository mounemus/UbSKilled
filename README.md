# JobHunter AI Pro - Application Mobile

Application mobile React Native pour la recherche d'emploi des francophones, intégrée avec le plugin WordPress JobHunter AI.

## 📱 Fonctionnalités

- **Analyse IA de CV** : Téléversez votre CV et obtenez un score ATS, des recommandations personnalisées
- **Recherche d'emplois** : Matching intelligent avec les offres d'emploi
- **Lettres de motivation IA** : Génération automatique personnalisée par offre
- **Suivi des candidatures** : Tableau de bord complet avec statistiques
- **Coach Carrière IA** : Assistant virtuel pour vos questions
- **Gamification** : Points, badges et niveaux pour rester motivé

## 🛠️ Prérequis

### Pour générer l'APK, vous avez besoin de :

1. **Node.js 18+** : [Télécharger](https://nodejs.org/)
2. **Java JDK 17+** : [Télécharger OpenJDK](https://adoptium.net/)
3. **Android SDK** : Via Android Studio ou manuellement

### Configuration Android SDK

```bash
# Définir les variables d'environnement
export ANDROID_HOME=$HOME/Android/Sdk  # ou votre chemin
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

## 🚀 Génération de l'APK

### Méthode 1 : Build Local (Recommandée)

```bash
# 1. Installer les dépendances
npm install

# 2. Générer le projet Android natif
npx expo prebuild --platform android --clean

# 3. Aller dans le dossier Android
cd android

# 4. Construire l'APK Release
./gradlew assembleRelease

# L'APK sera dans : android/app/build/outputs/apk/release/app-release.apk
```

### Méthode 2 : EAS Build (Cloud - Plus Simple)

```bash
# 1. Installer EAS CLI
npm install -g eas-cli

# 2. Se connecter à Expo (créer un compte sur expo.dev si nécessaire)
eas login

# 3. Configurer le projet
eas build:configure

# 4. Lancer le build APK
eas build --platform android --profile preview

# Le lien de téléchargement sera fourni à la fin du build
```

## 📦 Installation de l'APK

1. Transférez le fichier APK sur votre téléphone Android
2. Activez l'installation depuis des "Sources inconnues" dans les paramètres
3. Ouvrez le fichier APK pour l'installer

## 🔧 Configuration de l'API WordPress

Avant de compiler, configurez l'URL de votre WordPress dans :
`src/services/api/config.ts`

```typescript
export const API_CONFIG = {
  BASE_URL: __DEV__ 
    ? 'http://10.0.2.2/wordpress'  // Emulateur Android
    : 'https://votre-site.com',    // Production
  // ...
};
```

## 📁 Structure du Projet

```
jobhunter-mobile/
├── app/                      # Écrans (Expo Router)
│   ├── (auth)/              # Authentification
│   │   ├── login.tsx        # Connexion
│   │   ├── register.tsx     # Inscription
│   │   ├── onboarding.tsx   # Onboarding
│   │   └── forgot-password.tsx
│   ├── (tabs)/              # Navigation principale
│   │   ├── dashboard.tsx    # Tableau de bord
│   │   ├── jobs.tsx         # Recherche emplois
│   │   ├── cv.tsx           # Gestion CV
│   │   ├── applications.tsx # Candidatures
│   │   └── profile.tsx      # Profil
│   └── (modals)/            # Écrans modaux
│       ├── cover-letter.tsx # Génération lettre
│       └── ai-coach.tsx     # Chat IA
├── src/
│   ├── components/          # Composants réutilisables
│   ├── services/api/        # Services API
│   └── store/               # État Zustand
├── assets/                  # Images, icônes
├── wordpress-plugin/        # Extension API WordPress
├── app.json                 # Configuration Expo
├── eas.json                 # Configuration EAS Build
└── package.json             # Dépendances
```

## 🔑 Configuration WordPress

### 1. Copier les fichiers PHP

Copiez le contenu de `wordpress-plugin/includes/` dans votre plugin JobHunter AI :
- `class-jhai-mobile-rest-api.php`
- `class-jhai-database.php`

### 2. Activer l'API REST

Ajoutez dans `wp-config.php` :
```php
define('JWT_AUTH_SECRET_KEY', 'votre-clé-secrète-très-longue');
```

### 3. Vérifier les permaliens

Settings → Permalinks → Choisir une structure autre que "Plain"

## 🎨 Personnalisation

### Couleurs
Modifiez les thèmes dans `app/_layout.tsx` :
```typescript
const customLightTheme = {
  colors: {
    primary: '#1E3A5F',    // Couleur principale
    secondary: '#2E7D32',  // Couleur secondaire
    // ...
  }
};
```

### Icônes et Splash Screen
Remplacez les fichiers dans `assets/` :
- `icon.png` (1024x1024) - Icône de l'app
- `splash.png` (1284x2778) - Écran de chargement
- `adaptive-icon.png` (1024x1024) - Icône Android adaptative

## 🐛 Dépannage

### "ANDROID_HOME not set"
```bash
export ANDROID_HOME=$HOME/Android/Sdk
```

### "SDK location not found"
Créez `android/local.properties` :
```
sdk.dir=/chemin/vers/android/sdk
```

### Erreur de signature APK
Pour un APK de test non signé :
```bash
./gradlew assembleDebug
```

## 📄 Licence

Propriétaire - Tous droits réservés © Mounemus

## 🤝 Support

Pour toute question : support@jobhunterai.pro
