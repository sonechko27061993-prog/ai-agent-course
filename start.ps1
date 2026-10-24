$ErrorActionPreference = "Stop"
Write-Host "=== Starting AI Agent Infrastructure ===" -ForegroundColor Cyan

if (-not (Test-Path ".env")) {
    Copy-Item ".env.example" ".env"
    Write-Host "[!] Created .env from .env.example. Please add your TELEGRAM_BOT_TOKEN inside .env and run again." -ForegroundColor Yellow
    exit 1
}

Write-Host "[1/4] Starting Cloudflare HTTPS tunnel..."
docker compose up -d tunnel

Write-Host "[2/4] Fetching public HTTPS URL..."
$TunnelUrl = $null
for ($i = 0; $i -lt 20; $i++) {
    Start-Sleep -Seconds 2
    $Logs = docker logs ai_course_tunnel 2>&1 | Out-String
    if ($Logs -match "https://[a-zA-Z0-9-]+\.trycloudflare\.com") {
        $TunnelUrl = $Matches[0]
        break
    }
}

if (-not $TunnelUrl) {
    Write-Host "[Error] Could not get tunnel URL." -ForegroundColor Red
    exit 1
}

(Get-Content ".env") -replace "^WEBHOOK_URL=.*", "WEBHOOK_URL=$TunnelUrl/" | Set-Content ".env"

Write-Host "[3/4] Starting n8n (Timezone: Europe/Warsaw)..."
docker compose up -d n8n
Start-Sleep -Seconds 5

Write-Host "[4/4] Healthcheck:" -ForegroundColor Cyan
Write-Host "  [OK] Local n8n URL: http://localhost:5678" -ForegroundColor Green
Write-Host "  [OK] Public HTTPS Tunnel URL: $TunnelUrl" -ForegroundColor Green
