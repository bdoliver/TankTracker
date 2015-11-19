\set ON_ERROR_STOP 1
BEGIN TRANSACTION;

CREATE OR REPLACE FUNCTION set_updated_on()
RETURNS TRIGGER AS
$$
BEGIN
    NEW.updated_on := now();

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_user_updated
    BEFORE INSERT OR UPDATE ON users
    FOR EACH ROW EXECUTE PROCEDURE set_updated_on();

CREATE TRIGGER set_tank_updated
    BEFORE INSERT OR UPDATE ON tank
    FOR EACH ROW EXECUTE PROCEDURE set_updated_on();

CREATE TRIGGER set_diary_updated
    BEFORE INSERT OR UPDATE ON diary
    FOR EACH ROW EXECUTE PROCEDURE set_updated_on();

CREATE TRIGGER set_inventory_updated
    BEFORE INSERT OR UPDATE ON inventory
    FOR EACH ROW EXECUTE PROCEDURE set_updated_on();

CREATE TRIGGER set_tank_inventory_updated
    BEFORE INSERT OR UPDATE ON tank_inventory
    FOR EACH ROW EXECUTE PROCEDURE set_updated_on();

CREATE TRIGGER set_prefs_updated
    BEFORE INSERT OR UPDATE ON user_preferences
    FOR EACH ROW EXECUTE PROCEDURE set_updated_on();

COMMIT;
