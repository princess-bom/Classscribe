-- Simplify auth for single-user deployments by allowing inserts/updates without Supabase Auth

-- Ensure creator_id always has a value even when no auth user exists
ALTER TABLE events
  ALTER COLUMN creator_id SET DEFAULT '00000000-0000-0000-0000-000000000000'::uuid;

-- Relax event policies so anyone with the anon key can manage data
DROP POLICY IF EXISTS "Users can create events" ON events;
DROP POLICY IF EXISTS "Users can update their own events" ON events;
DROP POLICY IF EXISTS "Users can delete their own events" ON events;

CREATE POLICY "Anyone can create events"
  ON events FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Anyone can update events"
  ON events FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Anyone can delete events"
  ON events FOR DELETE
  USING (true);

-- Relax caption insert policy to match the single-user flow
DROP POLICY IF EXISTS "Event creators can add captions" ON captions;

CREATE POLICY "Anyone can add captions"
  ON captions FOR INSERT
  WITH CHECK (true);
