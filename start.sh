#!/usr/bin/env bash
set -e

if [ ! -f .env ]; then
    cp .env.example .env
    echo "[!] Created .env from template. Please fill in TELEGRAM_BOT_TOKEN in .env and run again."
    exit 1
fi

echo "[1/4] Starting Cloudflare HTTPS tunnel..."
docker compose up -d tunnel

echo "[2/4] Waiting for public HTTPS URL..."
TUNNEL_URL=""
for i in {1..20}; do
    sleep 2
    TUNNEL_URL=$(docker logs ai_course_tunnel 2>&1 | grep -oE "https://[a-zA-Z0-9-]+\.trycloudflare\.com" | head -n 1 || true)
    if [ -n "$TUNNEL_URL" ]; then
        break
    fi
done

if [ -z "$TUNNEL_URL" ]; then
    echo "[Error] Could not get HTTPS tunnel URL."
    exit 1
fi

sed -i.bak "s|^WEBHOOK_URL=.*|WEBHOOK_URL=${TUNNEL_URL}/|" .env && rm -f .env.bak

echo "[3/4] Starting local n8n (Europe/Warsaw)..."
docker compose up -d n8n
sleep 5

echo "[4/4] System status:"
echo "  [OK] Local n8n: http://localhost:5678"
echo "  [OK] Public HTTPS Tunnel: $TUNNEL_URL"
