-- QuoteVault Database Schema for Supabase
-- Run this in your Supabase SQL Editor

-- 1. Create profiles table (extends auth.users)
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Create categories table
CREATE TABLE IF NOT EXISTS categories (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  icon_name TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Create quotes table
CREATE TABLE IF NOT EXISTS quotes (
  id SERIAL PRIMARY KEY,
  content TEXT NOT NULL,
  author TEXT NOT NULL,
  category_id INTEGER REFERENCES categories(id),
  likes_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Create user_favorites table
CREATE TABLE IF NOT EXISTS user_favorites (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  quote_id INTEGER REFERENCES quotes(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, quote_id)
);

-- 5. Create collections table
CREATE TABLE IF NOT EXISTS collections (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  icon_name TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. Create collection_quotes junction table
CREATE TABLE IF NOT EXISTS collection_quotes (
  id SERIAL PRIMARY KEY,
  collection_id INTEGER REFERENCES collections(id) ON DELETE CASCADE,
  quote_id INTEGER REFERENCES quotes(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(collection_id, quote_id)
);

-- 7. Create daily_quotes table
CREATE TABLE IF NOT EXISTS daily_quotes (
  id SERIAL PRIMARY KEY,
  quote_id INTEGER REFERENCES quotes(id),
  date DATE UNIQUE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============ Row Level Security Policies ============

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE quotes ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE collections ENABLE ROW LEVEL SECURITY;
ALTER TABLE collection_quotes ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_quotes ENABLE ROW LEVEL SECURITY;

-- Profiles: Users can read all profiles but only update their own
CREATE POLICY "Public profiles are viewable by everyone" ON profiles FOR SELECT USING (true);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can insert own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

-- Categories: Everyone can read
CREATE POLICY "Categories are viewable by everyone" ON categories FOR SELECT USING (true);

-- Quotes: Everyone can read
CREATE POLICY "Quotes are viewable by everyone" ON quotes FOR SELECT USING (true);

-- User Favorites: Users can manage their own favorites
CREATE POLICY "Users can view own favorites" ON user_favorites FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own favorites" ON user_favorites FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own favorites" ON user_favorites FOR DELETE USING (auth.uid() = user_id);

-- Collections: Users can manage their own collections
CREATE POLICY "Users can view own collections" ON collections FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own collections" ON collections FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own collections" ON collections FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own collections" ON collections FOR DELETE USING (auth.uid() = user_id);

-- Collection Quotes: Users can manage quotes in their collections
CREATE POLICY "Users can view own collection quotes" ON collection_quotes FOR SELECT 
  USING (EXISTS (SELECT 1 FROM collections WHERE id = collection_id AND user_id = auth.uid()));
CREATE POLICY "Users can insert own collection quotes" ON collection_quotes FOR INSERT 
  WITH CHECK (EXISTS (SELECT 1 FROM collections WHERE id = collection_id AND user_id = auth.uid()));
CREATE POLICY "Users can delete own collection quotes" ON collection_quotes FOR DELETE 
  USING (EXISTS (SELECT 1 FROM collections WHERE id = collection_id AND user_id = auth.uid()));

-- Daily Quotes: Everyone can read
CREATE POLICY "Daily quotes are viewable by everyone" ON daily_quotes FOR SELECT USING (true);

-- ============ Trigger for auto-creating profile ============

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, name)
  VALUES (NEW.id, NEW.raw_user_meta_data->>'name');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ============ Seed Categories ============

INSERT INTO categories (name, icon_name) VALUES
  ('Motivation', 'rocket_launch'),
  ('Love', 'favorite'),
  ('Success', 'emoji_events'),
  ('Wisdom', 'psychology'),
  ('Humor', 'sentiment_satisfied')
ON CONFLICT (name) DO NOTHING;

-- ============ Seed Quotes (100+ quotes) ============

-- Motivation (20 quotes)
INSERT INTO quotes (content, author, category_id) VALUES
  ('The only way to do great work is to love what you do.', 'Steve Jobs', 1),
  ('It does not matter how slowly you go as long as you do not stop.', 'Confucius', 1),
  ('Success is not final, failure is not fatal: it is the courage to continue that counts.', 'Winston Churchill', 1),
  ('Believe you can and you''re halfway there.', 'Theodore Roosevelt', 1),
  ('The future belongs to those who believe in the beauty of their dreams.', 'Eleanor Roosevelt', 1),
  ('It is during our darkest moments that we must focus to see the light.', 'Aristotle', 1),
  ('The only impossible journey is the one you never begin.', 'Tony Robbins', 1),
  ('Success usually comes to those who are too busy to be looking for it.', 'Henry David Thoreau', 1),
  ('Don''t be afraid to give up the good to go for the great.', 'John D. Rockefeller', 1),
  ('I find that the harder I work, the more luck I seem to have.', 'Thomas Jefferson', 1),
  ('The way to get started is to quit talking and begin doing.', 'Walt Disney', 1),
  ('If you are working on something exciting, you don''t have to be pushed.', 'Steve Jobs', 1),
  ('The secret of getting ahead is getting started.', 'Mark Twain', 1),
  ('Don''t watch the clock; do what it does. Keep going.', 'Sam Levenson', 1),
  ('Everything you''ve ever wanted is on the other side of fear.', 'George Addair', 1),
  ('Opportunities don''t happen. You create them.', 'Chris Grosser', 1),
  ('The only limit to our realization of tomorrow is our doubts of today.', 'Franklin D. Roosevelt', 1),
  ('What you get by achieving your goals is not as important as what you become.', 'Zig Ziglar', 1),
  ('Your time is limited, don''t waste it living someone else''s life.', 'Steve Jobs', 1),
  ('Dream big and dare to fail.', 'Norman Vaughan', 1);

-- Love (20 quotes)
INSERT INTO quotes (content, author, category_id) VALUES
  ('The best thing to hold onto in life is each other.', 'Audrey Hepburn', 2),
  ('Love is composed of a single soul inhabiting two bodies.', 'Aristotle', 2),
  ('Where there is love there is life.', 'Mahatma Gandhi', 2),
  ('To love and be loved is to feel the sun from both sides.', 'David Viscott', 2),
  ('Love is not finding someone to live with; it''s finding someone you can''t live without.', 'Rafael Ortiz', 2),
  ('The greatest thing you''ll ever learn is just to love and be loved in return.', 'Eden Ahbez', 2),
  ('Love is friendship that has caught fire.', 'Ann Landers', 2),
  ('We are most alive when we''re in love.', 'John Updike', 2),
  ('Love doesn''t make the world go round. Love is what makes the ride worthwhile.', 'Franklin P. Jones', 2),
  ('Being deeply loved by someone gives you strength.', 'Lao Tzu', 2),
  ('You know you''re in love when you can''t fall asleep because reality is better than dreams.', 'Dr. Seuss', 2),
  ('Love is an act of endless forgiveness.', 'Peter Ustinov', 2),
  ('The heart has its reasons which reason knows not.', 'Blaise Pascal', 2),
  ('Love recognizes no barriers.', 'Maya Angelou', 2),
  ('In all the world, there is no heart for me like yours.', 'Maya Angelou', 2),
  ('The best love is the kind that awakens the soul.', 'Nicholas Sparks', 2),
  ('Love is the only force capable of transforming an enemy into a friend.', 'Martin Luther King Jr.', 2),
  ('Love is patient, love is kind.', 'Corinthians 13:4', 2),
  ('A loving heart is the truest wisdom.', 'Charles Dickens', 2),
  ('Keep love in your heart. A life without it is like a sunless garden.', 'Oscar Wilde', 2);

-- Success (20 quotes)
INSERT INTO quotes (content, author, category_id) VALUES
  ('Success is not the key to happiness. Happiness is the key to success.', 'Albert Schweitzer', 3),
  ('Try not to become a man of success, but rather a man of value.', 'Albert Einstein', 3),
  ('Success is walking from failure to failure with no loss of enthusiasm.', 'Winston Churchill', 3),
  ('The road to success and the road to failure are almost exactly the same.', 'Colin R. Davis', 3),
  ('Success is how high you bounce when you hit bottom.', 'George S. Patton', 3),
  ('I never dreamed about success. I worked for it.', 'Estée Lauder', 3),
  ('Success seems to be connected with action.', 'Conrad Hilton', 3),
  ('The successful warrior is the average man, with laser-like focus.', 'Bruce Lee', 3),
  ('Success is the sum of small efforts repeated day in and day out.', 'Robert Collier', 3),
  ('There are no secrets to success. It is the result of preparation and hard work.', 'Colin Powell', 3),
  ('Success is not in what you have, but who you are.', 'Bo Bennett', 3),
  ('Coming together is a beginning; keeping together is progress; working together is success.', 'Edward Everett Hale', 3),
  ('The only place where success comes before work is in the dictionary.', 'Vidal Sassoon', 3),
  ('Success is going from failure to failure without losing enthusiasm.', 'Winston Churchill', 3),
  ('Success is liking yourself, liking what you do, and liking how you do it.', 'Maya Angelou', 3),
  ('The real test is not whether you avoid failure, but whether you let it harden you.', 'Barack Obama', 3),
  ('Success is getting what you want. Happiness is wanting what you get.', 'Dale Carnegie', 3),
  ('I owe my success to having listened respectfully to the very best advice, and then going away and doing the exact opposite.', 'G.K. Chesterton', 3),
  ('A successful man is one who can lay a firm foundation with the bricks others have thrown at him.', 'David Brinkley', 3),
  ('Success is not measured by what you accomplish, but by the opposition you encounter.', 'Orison Swett Marden', 3);

-- Wisdom (20 quotes)
INSERT INTO quotes (content, author, category_id) VALUES
  ('The only true wisdom is in knowing you know nothing.', 'Socrates', 4),
  ('In the middle of difficulty lies opportunity.', 'Albert Einstein', 4),
  ('The mind is everything. What you think you become.', 'Buddha', 4),
  ('Life is what happens when you''re busy making other plans.', 'John Lennon', 4),
  ('The unexamined life is not worth living.', 'Socrates', 4),
  ('Turn your wounds into wisdom.', 'Oprah Winfrey', 4),
  ('The only thing permanent is change.', 'Heraclitus', 4),
  ('Knowledge speaks, but wisdom listens.', 'Jimi Hendrix', 4),
  ('The wise man does at once what the fool does finally.', 'Niccolò Machiavelli', 4),
  ('It is the mark of an educated mind to entertain a thought without accepting it.', 'Aristotle', 4),
  ('Knowing yourself is the beginning of all wisdom.', 'Aristotle', 4),
  ('The fool thinks he is wise, but the wise man knows himself to be a fool.', 'William Shakespeare', 4),
  ('Wisdom comes from experience, and experience comes from making mistakes.', 'Paulo Coelho', 4),
  ('A wise man can learn more from a foolish question than a fool can learn from a wise answer.', 'Bruce Lee', 4),
  ('The doorstep to wisdom is to know your own limitations.', 'Anthony de Mello', 4),
  ('Never mistake knowledge for wisdom.', 'Sandra Carey', 4),
  ('We are what we repeatedly do. Excellence is not an act, but a habit.', 'Aristotle', 4),
  ('By three methods we may learn wisdom: by reflection, by imitation, and by experience.', 'Confucius', 4),
  ('The measure of intelligence is the ability to change.', 'Albert Einstein', 4),
  ('Common sense is not so common.', 'Voltaire', 4);

-- Humor (21 quotes)
INSERT INTO quotes (content, author, category_id) VALUES
  ('I''m not arguing, I''m just explaining why I''m right.', 'Unknown', 5),
  ('I intend to live forever. So far, so good.', 'Steven Wright', 5),
  ('Behind every great man is a woman rolling her eyes.', 'Jim Carrey', 5),
  ('I''m writing a book. I''ve got the page numbers done.', 'Steven Wright', 5),
  ('I used to think I was indecisive, but now I''m not so sure.', 'Unknown', 5),
  ('Age is of no importance unless you''re a cheese.', 'Billie Burke', 5),
  ('I''m not lazy, I''m on energy-saving mode.', 'Unknown', 5),
  ('The only mystery in life is why the kamikaze pilots wore helmets.', 'Al McGuire', 5),
  ('I haven''t slept for ten days, because that would be too long.', 'Mitch Hedberg', 5),
  ('I''m an early bird and a night owl. So I''m wise and I have worms.', 'Michael Scott', 5),
  ('People say nothing is impossible, but I do nothing every day.', 'A.A. Milne', 5),
  ('I''m not superstitious, but I am a little stitious.', 'Michael Scott', 5),
  ('Light travels faster than sound. This is why some people appear bright until you hear them speak.', 'Alan Dundes', 5),
  ('I''m on a whiskey diet. I''ve lost three days already.', 'Tommy Cooper', 5),
  ('Laugh and the world laughs with you, snore and you sleep alone.', 'Anthony Burgess', 5),
  ('I''m not short, I''m concentrated awesome.', 'Unknown', 5),
  ('The best time to plant a tree was 20 years ago. The second best is now.', 'Chinese Proverb', 5),
  ('I told my wife she was drawing her eyebrows too high. She looked surprised.', 'Unknown', 5),
  ('I''m not clumsy. It''s just the floor hates me.', 'Unknown', 5),
  ('I''m on a seafood diet. I see food and I eat it.', 'Unknown', 5),
  ('Always borrow money from a pessimist. They''ll never expect it back.', 'Oscar Wilde', 5);
