# Script PowerShell para teste OTIMIZADO - BlazDemo Performance Test

Write-Host "🚀 VERSÃO OTIMIZADA - BlazDemo Performance Test" -ForegroundColor Green
Write-Host "🎯 Objetivo: Atingir 250+ RPS com p90 < 2s" -ForegroundColor Cyan
Write-Host "⚡ Think Time Reduzido: 200ms (Load) / 500ms (Spike)" -ForegroundColor Yellow
Write-Host ""

# Verificar se o K6 está instalado
try {
    & k6 version | Out-Null
    Write-Host "✅ K6 encontrado" -ForegroundColor Green
} catch {
    Write-Host "❌ K6 não encontrado. Instalando..." -ForegroundColor Red
    Write-Host "Use: choco install k6 ou winget install k6" -ForegroundColor Yellow
    exit 1
}

Write-Host "📊 Executando TESTE DE CARGA OTIMIZADO..." -ForegroundColor Green
Write-Host "⏱️  Think Time: 200ms" -ForegroundColor Cyan
Write-Host "🎯 Target: 250+ RPS" -ForegroundColor Cyan
Write-Host ""

# Executar teste de carga otimizado
$env:TEST_TYPE = "load"
$env:THINK_TIME_LOAD = "0.2"

& k6 run --config config/load-test.json --out json=reports/load-test-optimized-results.json --out html=reports/load-test-optimized-report.html src/main.js

Write-Host ""
Write-Host "✅ Teste de carga OTIMIZADO concluído!" -ForegroundColor Green
Write-Host "📁 Relatórios:" -ForegroundColor Cyan
Write-Host "   - HTML: reports/load-test-optimized-report.html" -ForegroundColor White
Write-Host "   - JSON: reports/load-test-optimized-results.json" -ForegroundColor White
Write-Host ""
Write-Host "🔍 Análise rápida:" -ForegroundColor Cyan
Write-Host "   - Verifique se RPS > 240" -ForegroundColor White
Write-Host "   - Verifique se p90 < 2000ms" -ForegroundColor White
Write-Host "   - Verifique taxa de sucesso > 95%" -ForegroundColor White

# Abrir relatório HTML automaticamente
if (Test-Path "reports/load-test-optimized-report.html") {
    Write-Host ""
    Write-Host "🌐 Abrindo relatório HTML..." -ForegroundColor Green
    Start-Process "reports/load-test-optimized-report.html"
}