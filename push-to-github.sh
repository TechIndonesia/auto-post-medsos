#!/usr/bin/env bash
#
# Upload / sinkronisasi project ini ke GitHub kamu — bisa OTOMATIS.
#
# ── MODE 1: OTOMATIS (tanpa ketik apa-apa lagi) ─────────────────────────────
#   Set 2 environment variable lebih dulu (sekali saja), lalu jalankan skrip:
#       export GITHUB_TOKEN="ghp_xxxxxxxxxxxxxxxxxxxx"   # Personal Access Token
#       export GITHUB_REPO="USERNAME/NAMA-REPO"          # repo tujuan
#       bash push-to-github.sh
#   Skrip akan commit + push sendiri tanpa minta password.
#
# ── MODE 2: MANUAL (sekali jalan) ───────────────────────────────────────────
#       bash push-to-github.sh https://github.com/USERNAME/NAMA-REPO.git
#   Saat diminta password, TEMPEL token (PAT), bukan password GitHub.
#
# Buat token di: https://github.com/settings/tokens
#   -> Generate new token (classic) -> centang scope: repo
#
set -e

BRANCH="${GITHUB_BRANCH:-main}"
ARG_URL="$1"

# Tentukan URL remote
if [ -n "$ARG_URL" ]; then
  REPO_URL="$ARG_URL"
elif [ -n "$GITHUB_TOKEN" ] && [ -n "$GITHUB_REPO" ]; then
  # Bentuk URL berisi token -> push otomatis tanpa prompt password
  GH_USER="${GITHUB_REPO%%/*}"
  REPO_URL="https://${GH_USER}:${GITHUB_TOKEN}@github.com/${GITHUB_REPO}.git"
  echo "🔐 Mode OTOMATIS: pakai GITHUB_TOKEN + GITHUB_REPO=${GITHUB_REPO}"
else
  echo "❌ Belum ada tujuan repo."
  echo ""
  echo "Pilih salah satu:"
  echo "  MODE OTOMATIS:"
  echo "    export GITHUB_TOKEN=ghp_xxx"
  echo "    export GITHUB_REPO=USERNAME/REPO"
  echo "    bash push-to-github.sh"
  echo ""
  echo "  MODE MANUAL:"
  echo "    bash push-to-github.sh https://github.com/USERNAME/REPO.git"
  exit 1
fi

# Inisialisasi git bila belum ada
[ -d .git ] || git init

git config user.name  "${GIT_AUTHOR_NAME:-AutoPost Studio}"   >/dev/null 2>&1 || true
git config user.email "${GIT_AUTHOR_EMAIL:-autopost@example.com}" >/dev/null 2>&1 || true

git add -A
git commit -m "${COMMIT_MESSAGE:-Update AutoPost Studio}" || echo "ℹ️  Tidak ada perubahan baru untuk di-commit."

git branch -M "$BRANCH"

if git remote | grep -q '^origin$'; then
  git remote set-url origin "$REPO_URL"
else
  git remote add origin "$REPO_URL"
fi

echo "🚀 Mengunggah ke GitHub (branch $BRANCH)..."
git push -u origin "$BRANCH"

# Bersihkan remote agar token tidak tersimpan di .git/config
if [ -n "$GITHUB_TOKEN" ] && [ -n "$GITHUB_REPO" ] && [ -z "$ARG_URL" ]; then
  git remote set-url origin "https://github.com/${GITHUB_REPO}.git"
  echo "🧹 Token dibersihkan dari konfigurasi git (keamanan)."
fi

echo ""
echo "✅ Selesai! Kode sudah ada di GitHub kamu. Import ke Vercel untuk hosting."
