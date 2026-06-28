# AutoPost Studio — Facebook · YouTube · TikTok

Dashboard untuk **memposting otomatis** iklan, foto, dan video ke Facebook Page,
YouTube, dan TikTok dari satu tempat. Bisa posting langsung atau dijadwalkan.

## Fitur
- 🤖 **Generate otomatis pakai Arena AI** — sekali klik membuat caption/judul (teks),
  foto AI, dan naskah + cover video. Cukup tulis prompt.
- 🔗 Kelola banyak akun (Facebook / YouTube / TikTok) lewat access token
- ✍️ Buat posting teks / foto / video dengan caption
- 🎯 Pilih beberapa akun tujuan sekaligus
- 🚀 Posting sekarang atau 🕒 jadwalkan
- 📋 Riwayat posting + status per platform + link hasil
- ⏰ Cron job otomatis memproses posting terjadwal (Vercel Cron)
- ⚙️ Tab Pengaturan untuk memasukkan Arena AI API key

## Arena AI (generate konten)
- Daftar di [arena.ai](https://arena.ai) → buat **virtual API key** di halaman Keys.
- Masukkan key di tab **Pengaturan** (disimpan di DB) atau set env var `ARENA_API_KEY`.
- Teks pakai endpoint `/v1/chat/completions`, foto pakai `/v1/images/generations`.
- Foto AI disimpan di database dan disajikan via `/api/media/[id]` sehingga punya
  URL publik yang bisa diambil Facebook.
- Catatan: Arena belum punya model video; untuk YouTube/TikTok kamu tetap menempel
  URL file video sendiri (naskah & cover dibuat AI).

## Deploy ke Vercel
1. Push project ini ke GitHub.
2. Import repo di Vercel.
3. Tambahkan environment variable **`DATABASE_URL`** (PostgreSQL, mis. Neon/Supabase/Vercel Postgres).
4. (Opsional) Tambahkan **`CRON_SECRET`** untuk mengamankan endpoint cron.
5. Setelah deploy pertama, jalankan migrasi schema: `npx drizzle-kit push`
   (arahkan `DATABASE_URL` ke database produksi).

`vercel.json` sudah memuat Cron Job tiap menit ke `/api/cron/publish`
untuk memproses posting terjadwal.

## Cara dapat Access Token
- **Facebook**: buat App di developers.facebook.com, ambil *Page Access Token*
  dengan izin `pages_manage_posts`, `pages_read_engagement`. Isi juga *Page ID*.
- **YouTube**: OAuth2 Google dengan scope `https://www.googleapis.com/auth/youtube.upload`.
  Token akses berumur pendek — perbarui berkala.
- **TikTok**: TikTok for Developers, scope `video.publish`. Domain URL video
  harus diverifikasi di app TikTok kamu (PULL_FROM_URL).

> Catatan: setiap platform punya proses review/izin tersendiri. Token yang valid
> wajib agar posting benar-benar terkirim.

## Stack
Next.js (App Router) · Drizzle ORM · PostgreSQL · Tailwind CSS
