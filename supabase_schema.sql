-- ============================================================================
-- UTS PEMROGRAMAN MOBILE - MIFTAH FADILATUS SAKHILA (NIM: 2415051011 - PTI 5A)
-- Skema Database PostgreSQL / Supabase untuk Aplikasi "MuncakGear"
-- Tema: Penyewaan Fasilitas Mendaki & Alat Outdoor
-- ============================================================================

-- 1. Tabel Rental Bookings (Transaksi Penyewaan Alat Outdoor)
-- Memenuhi syarat: Minimal 1 tabel dengan primary key + >= 4 field data (di sini 13 field)
CREATE TABLE IF NOT EXISTS rental_bookings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    student_id VARCHAR(50) DEFAULT '2415051011' NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    customer_phone VARCHAR(30) NOT NULL,
    gear_id VARCHAR(50) NOT NULL,
    gear_name VARCHAR(150) NOT NULL,
    rental_days INTEGER NOT NULL CHECK (rental_days > 0),
    start_date VARCHAR(50) NOT NULL,
    return_date VARCHAR(50) NOT NULL,
    total_price NUMERIC(12, 2) NOT NULL CHECK (total_price >= 0),
    note TEXT,
    status VARCHAR(30) DEFAULT 'Aktif' NOT NULL, -- 'Aktif', 'Selesai', 'Dibatalkan'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Index untuk performa pencarian data rental berdasarkan student_id dan status
CREATE INDEX IF NOT EXISTS idx_rental_student_id ON rental_bookings (student_id);
CREATE INDEX IF NOT EXISTS idx_rental_status ON rental_bookings (status);

-- 3. Row Level Security (RLS) & Policies
ALTER TABLE rental_bookings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow public read access"
    ON rental_bookings FOR SELECT
    USING (true);

CREATE POLICY "Allow public insert access"
    ON rental_bookings FOR INSERT
    WITH CHECK (true);

CREATE POLICY "Allow public update access"
    ON rental_bookings FOR UPDATE
    USING (true);

CREATE POLICY "Allow public delete access"
    ON rental_bookings FOR DELETE
    USING (true);

-- 4. Sample Data untuk Demonstrasi Awal
INSERT INTO rental_bookings (
    customer_name, customer_phone, gear_id, gear_name, rental_days, start_date, return_date, total_price, note, status
) VALUES 
('Ahmad Fauzan', '081234567890', 'gear_01', 'Tenda Dome Eiger 4P Storm Shelter', 3, '2026-11-10', '2026-11-13', 180000, 'Pendakian Gunung Rinjani', 'Aktif'),
('Siti Rahma', '085712345678', 'gear_03', 'Carrier Deuter Aircontact 60+10L', 2, '2026-11-12', '2026-11-14', 90000, 'Packing gear camp ground Batur', 'Aktif'),
('Bayu Putra', '087812345679', 'gear_05', 'Kompor Portable & Nesting DS-308', 4, '2026-11-05', '2026-11-09', 100000, 'Selesai tepat waktu dan bersih', 'Selesai');
