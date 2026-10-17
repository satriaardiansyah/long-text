-- ============================================================
-- SQL MIGRATION: Ranked Leaderboard Kata Terpanjang
-- Silakan jalankan script ini di SQL Editor dashboard Supabase:
-- https://supabase.com/dashboard/project/wlyiifkoeoqzejqkzatp/sql
-- ============================================================

-- 1. Buat Tabel ranked_leaderboard
CREATE TABLE IF NOT EXISTS public.ranked_leaderboard (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    username TEXT NOT NULL,
    time NUMERIC(6, 2) NOT NULL,            -- Waktu penyelesaian (detik)
    cps NUMERIC(5, 2) NOT NULL,             -- Characters Per Second
    wpm INTEGER NOT NULL,                   -- Words Per Minute perkiraan
    acc INTEGER NOT NULL DEFAULT 100,       -- Akurasi (%)
    typos INTEGER NOT NULL DEFAULT 0,       -- Jumlah typo
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    CONSTRAINT ranked_leaderboard_user_id_unique UNIQUE (user_id)
);

-- 2. Index untuk pengurutan leaderboard (waktu tercepat, lalu CPS tertinggi)
CREATE INDEX IF NOT EXISTS idx_ranked_leaderboard_rank 
ON public.ranked_leaderboard (time ASC, cps DESC);

-- 3. Aktifkan Row Level Security (RLS)
ALTER TABLE public.ranked_leaderboard ENABLE ROW LEVEL SECURITY;

-- 4. Policy: Siapapun (publik/anon & authenticated) dapat melihat leaderboard
DROP POLICY IF EXISTS "Allow public read leaderboard" ON public.ranked_leaderboard;
CREATE POLICY "Allow public read leaderboard"
    ON public.ranked_leaderboard
    FOR SELECT
    USING (true);

-- 5. Policy: User yang login dapat memasukkan rekor mereka
DROP POLICY IF EXISTS "Allow user insert own score" ON public.ranked_leaderboard;
CREATE POLICY "Allow user insert own score"
    ON public.ranked_leaderboard
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- 6. Policy: User yang login dapat memperbarui rekor jika lebih baik
DROP POLICY IF EXISTS "Allow user update own score" ON public.ranked_leaderboard;
CREATE POLICY "Allow user update own score"
    ON public.ranked_leaderboard
    FOR UPDATE
    USING (auth.uid() = user_id);

-- 7. Policy: User yang login dapat menghapus rekor sendiri
DROP POLICY IF EXISTS "Allow user delete own score" ON public.ranked_leaderboard;
CREATE POLICY "Allow user delete own score"
    ON public.ranked_leaderboard
    FOR DELETE
    USING (auth.uid() = user_id);

