#!/bin/bash
# Script para executar teste de carga - BlazDemo Performance Test

echo "🚀 Iniciando Teste de Carga BlazDemo"
echo "🎯 Objetivo: 250 RPS com p90 < 2s"
echo ""

# Verificar se o K6 está instalado
if ! command -v k6 &> /dev/null; then
    echo "❌ K6 não encontrado. Por favor, instale o K6:"
    echo "   - Windows: choco install k6"
    echo "   - macOS: brew install k6"
    echo "   - Linux: sudo apt update && sudo apt install k6"
    exit 1
fi

echo "📊 Executando teste de carga..."
k6 run --config config/load-test.json --out html=reports/load-test-report.html src/main.js

echo ""
echo "✅ Teste de carga concluído!"
echo "📁 Relatório HTML: reports/load-test-report.html"