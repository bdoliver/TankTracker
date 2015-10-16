\set ON_ERROR_STOP 1
BEGIN TRANSACTION;

CREATE TABLE signup (
    signup_id      SERIAL
                   NOT NULL
                   PRIMARY KEY,

    email          TEXT NOT NULL,
    hash           TEXT NOT NULL,
    -- user_id will only be set when an existing user
    -- issues an invite, so this col is nullable:
    user_id        INTEGER
                   REFERENCES users (user_id),

    created_on     TIMESTAMP(0) DEFAULT now()
);
CREATE UNIQUE INDEX email_idx ON signup ( lower(email) );
CREATE UNIQUE INDEX signup_hash_idx ON signup ( lower(hash) );

COMMIT;
