# Script para gerenciar múltiplas instâncias n8n
# Usage: .\scripts\manage-multiple.ps1

param(
    [Parameter(Mandatory=$false)]
    [string]$Action = "status",
    
    [Parameter(Mandatory=$false)]
    [string]$Project = ""
)

Write-Host "🔧 n8n Multi-Project Manager" -ForegroundColor Green
Write-Host ""

function Show-Status {
    Write-Host "📊 Status dos Projetos n8n:" -ForegroundColor Blue
    
    $n8nContainers = docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}" | findstr n8n
    
    if ($n8nContainers) {
        Write-Host $n8nContainers -ForegroundColor Cyan
    } else {
        Write-Host "Nenhum container n8n rodando" -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "🔍 Portas em uso:" -ForegroundColor Blue
    netstat -ano | findstr ":567[8-9]"
}

function Stop-All {
    Write-Host "🛑 Parando todos os containers n8n..." -ForegroundColor Yellow
    
    $containers = docker ps --format "{{.Names}}" | findstr n8n
    
    if ($containers) {
        $containers | ForEach-Object {
            Write-Host "Parando: $_" -ForegroundColor Yellow
            docker stop $_
        }
        Write-Host "✅ Todos os containers n8n foram parados" -ForegroundColor Green
    } else {
        Write-Host "Nenhum container n8n encontrado" -ForegroundColor Yellow
    }
}

function Start-Project {
    param([string]$ProjectPath)
    
    if (-not $ProjectPath) {
        Write-Host "❌ Especifique o projeto: -Project 'caminho/para/projeto'" -ForegroundColor Red
        return
    }
    
    if (-not (Test-Path $ProjectPath)) {
        Write-Host "❌ Projeto não encontrado: $ProjectPath" -ForegroundColor Red
        return
    }
    
    Write-Host "🚀 Iniciando projeto: $ProjectPath" -ForegroundColor Blue
    
    Push-Location $ProjectPath
    try {
        docker compose up -d
        Write-Host "✅ Projeto iniciado com sucesso!" -ForegroundColor Green
    } catch {
        Write-Host "❌ Erro ao iniciar projeto: $_" -ForegroundColor Red
    } finally {
        Pop-Location
    }
}

function Show-Help {
    Write-Host "📖 Uso do Script:" -ForegroundColor Blue
    Write-Host ""
    Write-Host "Status dos projetos:" -ForegroundColor White
    Write-Host "  .\scripts\manage-multiple.ps1 -Action status" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Parar todos os n8n:" -ForegroundColor White
    Write-Host "  .\scripts\manage-multiple.ps1 -Action stop-all" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Iniciar projeto específico:" -ForegroundColor White
    Write-Host "  .\scripts\manage-multiple.ps1 -Action start -Project 'caminho/projeto'" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Exemplos:" -ForegroundColor White
    Write-Host "  .\scripts\manage-multiple.ps1 status" -ForegroundColor Cyan
    Write-Host "  .\scripts\manage-multiple.ps1 stop-all" -ForegroundColor Cyan
    Write-Host "  .\scripts\manage-multiple.ps1 start -Project 'C:\projetos\meu-n8n'" -ForegroundColor Cyan
}

# Executar ação
switch ($Action.ToLower()) {
    "status" { Show-Status }
    "stop-all" { Stop-All }
    "start" { Start-Project -ProjectPath $Project }
    "help" { Show-Help }
    default { 
        Write-Host "❌ Ação inválida: $Action" -ForegroundColor Red
        Show-Help
    }
}
