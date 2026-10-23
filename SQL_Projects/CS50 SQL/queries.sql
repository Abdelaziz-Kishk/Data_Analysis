INSERT INTO "city" ("id", "name", "location", "country") VALUES
(1, 'Cairo', 'Downtown', 'Egypt'),
(2, 'New York', 'Manhattan', 'USA');

INSERT INTO "users" ("id", "First_name", "last_name", "email", "password", "city_id") VALUES
(1, 'Alice', 'Smith', 'alice@example.com', 'password123', 1),
(2, 'Bob', 'Jones', 'bob@example.com', 'securepass', 1),
(3, 'Charlie', 'Brown', 'charlie@example.com', 'mypassword', 2);

INSERT INTO "connections" ("user_id", "connected_user_id", "status") VALUES
(1, 2, 'accepted');

INSERT INTO "events" ("id", "title", "description", "city_id", "host_id", "event_time") VALUES
(1, 'Board Games Night', 'Casual games night for newcomers in Cairo!', 1, 1, '2026-10-01 18:00:00');

SELECT "First_name", "last_name", "email"
FROM "users"
WHERE "city_id" = 1;

SELECT "events"."title", "events"."description", "events"."event_time", "users"."First_name" AS "host_name"
FROM "events"
JOIN "users" ON "events"."host_id" = "users"."id"
WHERE "events"."city_id" = 1;

SELECT "users"."First_name", "users"."last_name", "users"."email"
FROM "connections"
JOIN "users" ON "connections"."connected_user_id" = "users"."id"
WHERE "connections"."user_id" = 1 AND "connections"."status" = 'accepted';

UPDATE "users"
SET "city_id" = 2
WHERE "id" = 1;

UPDATE "connections"
SET "status" = 'accepted'
WHERE "user_id" = 1 AND "connected_user_id" = 2;

DELETE FROM "connections"
WHERE "user_id" = 1 AND "connected_user_id" = 2;

DELETE FROM "events"
WHERE "id" = 1;
