-- ============================================================
-- SQL MIGRATION: Multi-Word Ranked Leaderboard
-- Jalankan script ini di SQL Editor dashboard Supabase:
-- https://supabase.com/dashboard/project/wlyiifkoeoqzejqkzatp/sql
-- ============================================================

-- 1. Buat Tabel ranked_leaderboard jika belum ada
CREATE TABLE IF NOT EXISTS public.ranked_leaderboard (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    username TEXT NOT NULL,
    word_id TEXT NOT NULL DEFAULT 'taumata', -- 'taumata', 'muvaffakiyet', 'rindfleisch', 'llanfair', 'pneumono'
    time NUMERIC(6, 2) NOT NULL,            -- Waktu penyelesaian (detik)
    cps NUMERIC(5, 2) NOT NULL,             -- Characters Per Second
    wpm INTEGER NOT NULL,                   -- Words Per Minute perkiraan
    acc INTEGER NOT NULL DEFAULT 100,       -- Akurasi (%)
    typos INTEGER NOT NULL DEFAULT 0,       -- Jumlah typo
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- 2. Tambahkan kolom word_id jika tabel lama sudah terlanjur dibuat
ALTER TABLE public.ranked_leaderboard 
ADD COLUMN IF NOT EXISTS word_id TEXT NOT NULL DEFAULT 'taumata';

-- 3. Update Constraint: 1 Rekor Terbaik per User per Kata Monster
ALTER TABLE public.ranked_leaderboard 
DROP CONSTRAINT IF EXISTS ranked_leaderboard_user_id_unique;

ALTER TABLE public.ranked_leaderboard 
DROP CONSTRAINT IF EXISTS ranked_leaderboard_user_word_unique;

ALTER TABLE public.ranked_leaderboard 
ADD CONSTRAINT ranked_leaderboard_user_word_unique UNIQUE (user_id, word_id);

-- 4. Index untuk filter per kata & urutan ranking (waktu tercepat, lalu CPS tertinggi)
DROP INDEX IF EXISTS public.idx_ranked_leaderboard_rank;
CREATE INDEX IF NOT EXISTS idx_ranked_leaderboard_word_rank 
ON public.ranked_leaderboard (word_id, time ASC, cps DESC);

-- 5. Aktifkan Row Level Security (RLS)
ALTER TABLE public.ranked_leaderboard ENABLE ROW LEVEL SECURITY;

-- 6. Policy: Publik (anon & authenticated) dapat melihat leaderboard
DROP POLICY IF EXISTS "Allow public read leaderboard" ON public.ranked_leaderboard;
CREATE POLICY "Allow public read leaderboard"
    ON public.ranked_leaderboard
    FOR SELECT
    USING (true);

-- 7. Policy: User yang login dapat memasukkan rekor mereka
DROP POLICY IF EXISTS "Allow user insert own score" ON public.ranked_leaderboard;
CREATE POLICY "Allow user insert own score"
    ON public.ranked_leaderboard
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- 8. Policy: User yang login dapat memperbarui rekor jika lebih baik
DROP POLICY IF EXISTS "Allow user update own score" ON public.ranked_leaderboard;
CREATE POLICY "Allow user update own score"
    ON public.ranked_leaderboard
    FOR UPDATE
    USING (auth.uid() = user_id);

-- 9. Policy: User yang login dapat menghapus rekor sendiri
DROP POLICY IF EXISTS "Allow user delete own score" ON public.ranked_leaderboard;
CREATE POLICY "Allow user delete own score"
    ON public.ranked_leaderboard
    FOR DELETE
    USING (auth.uid() = user_id);
