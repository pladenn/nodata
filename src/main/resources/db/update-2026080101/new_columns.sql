ALTER TABLE parameter ADD COLUMN if not exists "description" TEXT;

ALTER TABLE action ADD COLUMN if not exists "name" TEXT;
