BEGIN;

-- Create function for performing delegates snapshot
CREATE FUNCTION perform_delegates_snapshot() RETURNS TRIGGER LANGUAGE PLPGSQL AS $$
	BEGIN
	    EXECUTE 'DROP TABLE IF EXISTS delegates_snapshot';
        EXECUTE 'CREATE TABLE delegates_snapshot AS SELECT address, pk, rank FROM delegates';
	RETURN NEW;
END $$;

-- Create trigger that will execute 'perform_delegates_snapshot' before insertion of last block of round
CREATE TRIGGER perform_delegates_snapshot
	BEFORE INSERT ON blocks
	FOR EACH ROW
	WHEN (NEW.height % 101 = 0 OR NEW.height = 1)
	EXECUTE PROCEDURE perform_delegates_snapshot();

COMMIT;
