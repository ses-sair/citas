#!/bin/bash

echo "📱 Citas App - Demo de Plataformas"
echo "=================================="

export PATH="/opt/flutter/bin:$PATH"

echo ""
echo "🔍 Dispositivos disponibles:"
flutter devices

echo ""
echo "📋 Estado del entorno de desarrollo:"
flutter doctor

echo ""
echo "🚀 Opciones para ejecutar la aplicación:"
echo ""
echo "1. 🌐 Web (Chrome):"
echo "   flutter run -d chrome --web-port=8080"
echo ""
echo "2. 🐧 Linux Desktop:"
echo "   flutter run -d linux"
echo ""
echo "3. 📱 Android (requiere emulador o dispositivo):"
echo "   flutter run -d android"
echo ""
echo "4. 🍎 iOS (requiere macOS, Xcode y simulador):"
echo "   flutter run -d ios"
echo ""

echo "💡 Para instalar emuladores:"
echo "   flutter emulators --launch <emulator_id>"
echo ""

echo "🔧 Para compilar para producción:"
echo "   Web:     flutter build web"
echo "   Android: flutter build apk"
echo "   iOS:     flutter build ios"

echo ""
echo "¿Qué plataforma quieres probar? [web/linux/android/ios]"
