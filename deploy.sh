#!/bin/bash

# Script de despliegue para GitHub Pages
# Ejecutar con: chmod +x deploy.sh && ./deploy.sh

echo "🚀 Iniciando proceso de despliegue..."

# Verificar que Flutter esté instalado
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter no está instalado. Por favor instala Flutter primero."
    exit 1
fi

echo "✅ Flutter encontrado: $(flutter --version | head -n 1)"

# Limpiar builds anteriores
echo "🧹 Limpiando builds anteriores..."
rm -rf build/
flutter clean

# Instalar dependencias
echo "📦 Instalando dependencias..."
flutter pub get

# Construir para web con base-href para GitHub Pages
echo "🔨 Construyendo aplicación para web..."
flutter build web --release --base-href="/citas/"

# Verificar que el build fue exitoso
if [ $? -eq 0 ]; then
    echo "✅ Build completado exitosamente"
    echo "📁 Archivos generados en: build/web/"
    echo ""
    echo "📋 Próximos pasos para desplegar en GitHub Pages:"
    echo "1. Crear repositorio 'citas' en GitHub"
    echo "2. Subir todo el código al repositorio"
    echo "3. Ir a Settings > Pages > Source: GitHub Actions"
    echo "4. O copiar contenido de build/web/ a rama gh-pages"
    echo ""
    echo "🌐 Para otros servicios:"
    echo "• Netlify: Arrastrar carpeta build/web/ a netlify.com"
    echo "• Vercel: Conectar repositorio GitHub"
    echo "• Firebase: flutter pub global activate flutterfire_cli && firebase deploy"
    echo ""
    echo "🎉 ¡Listo para despliegue!"
else
    echo "❌ Error durante el build"
    exit 1
fi
