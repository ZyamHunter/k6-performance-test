#!/bin/bash
# Script para testar a versão OTIMIZADA - BlazDemo Performance Test

echo "🚀 VERSÃO OTIMIZADA - BlazDemo Performance Test"
echo "🎯 Objetivo: Atingir 250+ RPS com p90 < 2s"
echo "⚡ Think Time Reduzido: 200ms (Load) / 500ms (Spike)"
echo ""

# Verificar se o K6 está instalado
if ! command -v k6 &> /dev/null; then
    echo "❌ K6 não encontrado. Por favor, instale o K6:"
    echo "   - Windows: choco install k6"
    echo "   - macOS: brew install k6"
    echo "   - Linux: sudo apt update && sudo apt install k6"
    exit 1
fi

echo "📊 Executando TESTE DE CARGA OTIMIZADO..."
echo "⏱️  Think Time: 200ms"
echo "🎯 Target: 250+ RPS"
echo ""

# Executar teste de carga otimizado
k6 run --config config/load-test.json \
       --env TEST_TYPE=load \
       --env THINK_TIME_LOAD=0.2 \
       --out json=reports/load-test-optimized-results.json \
       --out html=reports/load-test-optimized-report.html \
       src/main.js

echo ""
echo "✅ Teste de carga OTIMIZADO concluído!"
echo "📁 Relatórios:"
echo "   - HTML: reports/load-test-optimized-report.html"
echo "   - JSON: reports/load-test-optimized-results.json"
echo ""
echo "🔍 Análise rápida:"
echo "   - Verifique se RPS > 240"
echo "   - Verifique se p90 < 2000ms"
echo "   - Verifique taxa de sucesso > 95%"