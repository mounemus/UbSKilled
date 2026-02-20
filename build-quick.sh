#!/bin/bash

# ============================================================
# JobHunter AI Pro - Build APK Rapide
# ============================================================
# Exécutez ce script pour générer un APK installable
# Usage: ./build-quick.sh
# ============================================================

set -e

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║           JobHunter AI Pro - Build APK                   ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Vérifier Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js n'est pas installé"
    echo "   Téléchargez-le sur: https://nodejs.org/"
    exit 1
fi
echo "✅ Node.js $(node -v)"

# Vérifier Java
if ! command -v java &> /dev/null; then
    echo "❌ Java n'est pas installé"
    echo "   Téléchargez-le sur: https://adoptium.net/"
    exit 1
fi
echo "✅ Java OK"

# Vérifier ANDROID_HOME
if [ -z "$ANDROID_HOME" ]; then
    # Essayer de le trouver
    for path in "$HOME/Android/Sdk" "$HOME/Library/Android/sdk" "/usr/local/android-sdk"; do
        if [ -d "$path" ]; then
            export ANDROID_HOME="$path"
            break
        fi
    done
fi

if [ -z "$ANDROID_HOME" ]; then
    echo "❌ Android SDK non trouvé"
    echo "   Installez Android Studio ou définissez ANDROID_HOME"
    exit 1
fi
echo "✅ Android SDK: $ANDROID_HOME"

echo ""
echo "📦 Installation des dépendances..."
npm install --silent

echo ""
echo "🔨 Génération du projet Android..."
npx expo prebuild --platform android --clean

echo ""
echo "🏗️  Construction de l'APK..."
cd android
chmod +x gradlew
./gradlew assembleRelease --warning-mode=none

echo ""
echo "✨ Build terminé!"
echo ""

# Trouver et copier l'APK
APK_PATH=$(find app/build/outputs/apk -name "*.apk" | head -1)
if [ -n "$APK_PATH" ]; then
    cp "$APK_PATH" "../JobHunterAIPro.apk"
    echo "📱 APK disponible: JobHunterAIPro.apk"
    echo "   Taille: $(du -h ../JobHunterAIPro.apk | cut -f1)"
    echo ""
    echo "Pour installer:"
    echo "   1. Transférez JobHunterAIPro.apk sur votre téléphone"
    echo "   2. Activez 'Sources inconnues' dans les paramètres"
    echo "   3. Ouvrez le fichier APK"
else
    echo "❌ APK non trouvé"
fi
