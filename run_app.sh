#!/bin/bash

# Script para ejecutar la aplicación de citas

echo "🚀 Iniciando Citas App..."

# Verificar que Flutter esté instalado
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter no está instalado o no está en el PATH"
    echo "Agregando Flutter al PATH..."
    export PATH="/opt/flutter/bin:$PATH"
fi

# Verificar la versión de Flutter
echo "📋 Verificando Flutter..."
flutter --version

# Instalar dependencias
echo "📦 Instalando dependencias..."
flutter pub get

# Ejecutar la aplicación
echo "🌐 Ejecutando la aplicación en Chrome..."
flutter run -d chrome --web-port=8080

echo "✅ ¡Listo! La aplicación debería abrirse en tu navegador."
echo "🔗 URL: http://localhost:8080"
