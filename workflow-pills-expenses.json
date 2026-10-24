# Локальная инфраструктура для AI-агента (Таблетки и Расходы)

Минимальный локальный пакет для запуска **n8n** и публичного **HTTPS-туннеля (Cloudflare)** для работы с Telegram-ботом (часовой пояс: Польша, `Europe/Warsaw`).

## Что входит в пакет
* `docker-compose.yml` — запуск локального сервера `n8n` и HTTPS-туннеля `cloudflared`.
* `.env.example` — шаблон переменных окружения (без секретов).
* `.gitignore` — защита файла `.env` и локальной базы от попадания в Git.
* `start.ps1` / `start.sh` — скрипты автозапуска для Windows и macOS/Linux (сами получают HTTPS-адрес туннеля и передают его в `n8n`).
* `workflow-pills-expenses.json` — готовый шаблон AI-агента для контроля приёма таблеток и учёта финансов.

## Быстрый старт для студента
1. Установите и запустите **Docker Desktop**.
2. Скопируйте файл `.env.example` в новый файл `.env`:
   * Впишите внутри `.env` ваш `TELEGRAM_BOT_TOKEN` (от `@BotFather`) и `OPENAI_API_KEY`.
3. Запустите проект одной командой:
   * **Windows (PowerShell):** `./start.ps1`
   * **macOS / Linux:** `chmod +x start.sh && ./start.sh`
4. Откройте в браузере `http://localhost:5678`, импортируйте файл `workflow-pills-expenses.json` и активируйте сценарий.
