#!/bin/bash

# JobHunter AI Pro - Build APK via EAS
# Exécutez ce script sur votre machine locale

echo "🚀 JobHunter AI Pro - Build APK"
echo "================================"

# Vérifier Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js requis. Installez-le depuis https://nodejs.org/"
    exit 1
fi

# Installer les dépendances
echo "📦 Installation des dépendances..."
npm install

# Installer EAS CLI si nécessaire
if ! command -v eas &> /dev/null; then
    echo "📦 Installation de EAS CLI..."
    npm install -g eas-cli
fi

# Login
echo ""
echo "🔐 Connexion à Expo..."
eas login

# Lancer le build APK
echo ""
echo "🏗️  Lancement du build APK..."
eas build --platform android --profile preview

echo ""
echo "✅ Build lancé ! Suivez la progression sur https://expo.dev"
