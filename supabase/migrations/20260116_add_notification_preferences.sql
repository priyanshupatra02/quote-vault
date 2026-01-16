-- Migration: Add notification columns to profiles table
-- Authored: 2026-01-16

-- 1. Add notification_enabled (boolean, default false)
ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS notification_enabled BOOLEAN DEFAULT false;

-- 2. Add notification_hour (integer, default 9)
ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS notification_hour INTEGER DEFAULT 9;

-- 3. Add notification_minute (integer, default 0)
ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS notification_minute INTEGER DEFAULT 0;

-- 4. Comment on columns
COMMENT ON COLUMN profiles.notification_enabled IS 'User preference for daily quote push notifications';
COMMENT ON COLUMN profiles.notification_hour IS 'Hour of day (0-23) for daily quote';
COMMENT ON COLUMN profiles.notification_minute IS 'Minute of hour (0-59) for daily quote';
