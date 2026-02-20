#!/bin/bash

# ============================================================
# JobHunter AI Pro - Script de Build APK
# ============================================================
# Ce script génère un fichier APK prêt à installer sur Android
# 
# Prérequis:
# - Node.js 18+ installé
# - Java JDK 17+ installé
# - Android SDK installé avec:
#   - Android SDK Platform 34
#   - Android SDK Build-Tools 34.0.0
#   - Android SDK Platform-Tools
# ============================================================

set -e

echo "🚀 JobHunter AI Pro - Build APK"
echo "================================"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction pour afficher les messages
info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
success() { echo -e "${GREEN}✅ $1${NC}"; }
warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
error() { echo -e "${RED}❌ $1${NC}"; exit 1; }

# Vérifier les prérequis
check_prerequisites() {
    info "Vérification des prérequis..."
    
    # Node.js
    if ! command -v node &> /dev/null; then
        error "Node.js n'est pas installé. Installez-le depuis https://nodejs.org/"
    fi
    NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -lt 18 ]; then
        error "Node.js 18+ est requis. Version actuelle: $(node -v)"
    fi
    success "Node.js $(node -v)"
    
    # Java
    if ! command -v java &> /dev/null; then
        error "Java JDK n'est pas installé"
    fi
    success "Java $(java -version 2>&1 | head -n 1)"
    
    # Android SDK
    if [ -z "$ANDROID_HOME" ] && [ -z "$ANDROID_SDK_ROOT" ]; then
        warning "ANDROID_HOME n'est pas défini"
        
        # Essayer de trouver le SDK
        POSSIBLE_PATHS=(
            "$HOME/Android/Sdk"
            "$HOME/Library/Android/sdk"
            "/usr/local/android-sdk"
            "$HOME/android-sdk"
        )
        
        for path in "${POSSIBLE_PATHS[@]}"; do
            if [ -d "$path" ]; then
                export ANDROID_HOME="$path"
                export ANDROID_SDK_ROOT="$path"
                success "Android SDK trouvé: $path"
                break
            fi
        done
        
        if [ -z "$ANDROID_HOME" ]; then
            error "Android SDK non trouvé. Installez-le via Android Studio ou sdkmanager"
        fi
    else
        export ANDROID_HOME="${ANDROID_HOME:-$ANDROID_SDK_ROOT}"
        export ANDROID_SDK_ROOT="$ANDROID_HOME"
        success "Android SDK: $ANDROID_HOME"
    fi
    
    # PATH
    export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$PATH"
}

# Installer les dépendances
install_dependencies() {
    info "Installation des dépendances..."
    npm install
    success "Dépendances installées"
}

# Générer le projet Android natif
generate_android_project() {
    info "Génération du projet Android natif..."
    
    # Supprimer l'ancien projet Android si existant
    if [ -d "android" ]; then
        warning "Suppression de l'ancien projet Android..."
        rm -rf android
    fi
    
    # Exécuter expo prebuild
    npx expo prebuild --platform android --clean
    
    if [ ! -d "android" ]; then
        error "Échec de la génération du projet Android"
    fi
    
    success "Projet Android généré"
}

# Construire l'APK
build_apk() {
    info "Construction de l'APK..."
    
    cd android
    
    # Donner les permissions d'exécution à gradlew
    chmod +x gradlew
    
    # Build Debug APK (plus rapide, ne nécessite pas de keystore)
    ./gradlew assembleRelease --no-daemon
    
    cd ..
    
    # Trouver l'APK généré
    APK_PATH=$(find android/app/build/outputs/apk -name "*.apk" | head -1)
    
    if [ -z "$APK_PATH" ]; then
        error "APK non trouvé après le build"
    fi
    
    # Copier l'APK dans le dossier racine
    APK_NAME="JobHunterAIPro-$(date +%Y%m%d-%H%M%S).apk"
    cp "$APK_PATH" "./$APK_NAME"
    
    success "APK créé: $APK_NAME"
    echo ""
    echo "📱 Votre APK est prêt!"
    echo "   Fichier: $(pwd)/$APK_NAME"
    echo "   Taille: $(du -h "$APK_NAME" | cut -f1)"
    echo ""
    echo "Pour installer sur votre téléphone:"
    echo "   1. Transférez le fichier APK sur votre téléphone"
    echo "   2. Activez 'Sources inconnues' dans les paramètres"
    echo "   3. Ouvrez le fichier APK pour l'installer"
}

# Méthode alternative avec EAS Build (cloud)
build_with_eas() {
    info "Construction avec EAS Build (cloud)..."
    
    # Vérifier si eas-cli est installé
    if ! command -v eas &> /dev/null; then
        info "Installation de eas-cli..."
        npm install -g eas-cli
    fi
    
    # Se connecter à Expo (nécessite un compte)
    echo ""
    echo "📝 Vous devez vous connecter à votre compte Expo"
    echo "   Si vous n'avez pas de compte, créez-en un sur https://expo.dev"
    echo ""
    
    eas login
    
    # Construire l'APK
    eas build --platform android --profile preview
    
    success "Build lancé sur EAS!"
    echo "   Suivez la progression sur https://expo.dev"
}

# Menu principal
main() {
    echo ""
    echo "Choisissez une méthode de build:"
    echo ""
    echo "  1) Build local (nécessite Android SDK)"
    echo "  2) Build cloud EAS (nécessite compte Expo)"
    echo "  3) Vérifier les prérequis seulement"
    echo ""
    read -p "Votre choix [1-3]: " choice
    
    case $choice in
        1)
            check_prerequisites
            install_dependencies
            generate_android_project
            build_apk
            ;;
        2)
            install_dependencies
            build_with_eas
            ;;
        3)
            check_prerequisites
            success "Tous les prérequis sont satisfaits!"
            ;;
        *)
            error "Choix invalide"
            ;;
    esac
}

# Exécuter
main "$@"
