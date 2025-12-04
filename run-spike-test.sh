#!/bin/bash
# Script para executar teste de pico - BlazDemo Performance Test

echo "🚀 Iniciando Teste de Pico BlazDemo"
echo "⚡ Objetivo: Validar comportamento em picos de tráfego"
echo ""

# Verificar se o K6 está instalado
if ! command -v k6 &> /dev/null; then
    echo "❌ K6 não encontrado. Por favor, instale o K6:"
    echo "   - Windows: choco install k6"
    echo "   - macOS: brew install k6"
    echo "   - Linux: sudo apt update && sudo apt install k6"
    exit 1
fi

echo "📊 Executando teste de pico..."
k6 run --config config/spike-test.json --out html=reports/spike-test-report.html src/main.js

echo ""
echo "✅ Teste de pico concluído!"
echo "📁 Relatório HTML: reports/spike-test-report.html"