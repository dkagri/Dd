-- ============================================================================
-- KANDY DATA COLLECTION (FieldWork OS) - SUPABASE SCHEMA UPDATES
-- ============================================================================

-- 1. Item Price List Table
CREATE TABLE IF NOT EXISTS public.item_prices (
    id TEXT PRIMARY KEY,
    year TEXT NOT NULL,
    program TEXT NOT NULL,
    item_name TEXT NOT NULL,
    subsidy NUMERIC NOT NULL, -- 0.75, 0.50, 0.25, 0
    unit_price NUMERIC NOT NULL,
    gov_price NUMERIC GENERATED ALWAYS AS (unit_price - (subsidy * unit_price)) STORED,
    farmer_price NUMERIC GENERATED ALWAYS AS (subsidy * unit_price) STORED,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Targets & Progress Table (AD / AI Office Level Tracking)
CREATE TABLE IF NOT EXISTS public.targets_progress (
    id TEXT PRIMARY KEY,
    main_type TEXT NOT NULL, -- 'extension' or 'development'
    node_id TEXT NOT NULL,
    node_path TEXT,
    level1 TEXT,
    level2 TEXT,
    level3 TEXT,
    item_name TEXT,
    ad_office_id TEXT NOT NULL,
    ad_office_name TEXT,
    ai_office_id TEXT NOT NULL,
    target_units NUMERIC DEFAULT 0,
    progress_units NUMERIC DEFAULT 0,
    unit_price NUMERIC DEFAULT 0,
    subsidy NUMERIC DEFAULT 0,
    gov_price NUMERIC DEFAULT 0,
    farmer_price NUMERIC DEFAULT 0,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable RLS
ALTER TABLE public.item_prices ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.targets_progress ENABLE ROW LEVEL SECURITY;

-- Policies
DROP POLICY IF EXISTS "Allow all read item_prices" ON public.item_prices;
CREATE POLICY "Allow all read item_prices" ON public.item_prices FOR SELECT USING (true);
DROP POLICY IF EXISTS "Allow all write item_prices" ON public.item_prices;
CREATE POLICY "Allow all write item_prices" ON public.item_prices FOR ALL USING (true);

DROP POLICY IF EXISTS "Allow all read targets_progress" ON public.targets_progress;
CREATE POLICY "Allow all read targets_progress" ON public.targets_progress FOR SELECT USING (true);
DROP POLICY IF EXISTS "Allow all write targets_progress" ON public.targets_progress FOR ALL USING (true);

insert into public.profiles (username, name, role, status)
values ('gdkgdk1194@gmail.com', 'Main Admin', 'main_admin', 'active')
on conflict (username) do nothing;
