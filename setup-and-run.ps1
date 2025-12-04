# Script para instalar K6 e executar testes de performance
# BlazDemo Performance Test - Setup e Execução

Write-Host "🚀 Iniciando setup do K6 Performance Test" -ForegroundColor Green
Write-Host ""

# Verificar se o Chocolatey está instalado
try {
    choco --version | Out-Null
    Write-Host "✅ Chocolatey encontrado" -ForegroundColor Green
} catch {
    Write-Host "❌ Chocolatey não encontrado. Instalando..." -ForegroundColor Yellow
    Write-Host "Por favor, execute como Administrador:" -ForegroundColor Red
    Write-Host "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Após instalar o Chocolatey, execute novamente este script." -ForegroundColor Yellow
    exit 1
}

# Verificar se o K6 está instalado
try {
    k6 version | Out-Null
    Write-Host "✅ K6 já está instalado" -ForegroundColor Green
} catch {
    Write-Host "📦 Instalando K6..." -ForegroundColor Yellow
    choco install k6 -y
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ K6 instalado com sucesso" -ForegroundColor Green
    } else {
        Write-Host "❌ Erro ao instalar K6" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "🔧 Configuração concluída!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Comandos disponíveis:" -ForegroundColor Cyan
Write-Host "  npm run test:load        - Executar teste de carga" -ForegroundColor White
Write-Host "  npm run test:spike       - Executar teste de pico" -ForegroundColor White
Write-Host "  npm run test:load-report - Executar teste de carga com relatório HTML" -ForegroundColor White
Write-Host "  npm run test:spike-report- Executar teste de pico com relatório HTML" -ForegroundColor White
Write-Host ""
Write-Host "🎯 Executando teste de carga com relatório..." -ForegroundColor Green

# Executar teste de carga com relatório
k6 run --config config/load-test.json --out html=reports/load-test-report.html src/main.js

Write-Host ""
Write-Host "📊 Teste de carga concluído!" -ForegroundColor Green
Write-Host "📁 Relatório salvo em: reports/load-test-report.html" -ForegroundColor Cyan