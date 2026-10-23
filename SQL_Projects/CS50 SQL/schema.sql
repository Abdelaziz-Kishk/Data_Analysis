Create table "users"(
    "id" Integer Primary Key,
    "First_name" text not null,
    "last_name" text not null,
    "email" text check("email" LiKE '%@%'),
    "password" text not null,
    "city_id" Integer not null,
    Foreign Key ("city_id") References "city"("id")
);

Create table "city"(
    "id" Integer Primary Key,
    "location" text not null,
    "name" text not null,
    "country" text not null
);

Create table "connections"(
    "user_id" Integer,
    "connected_user_id" Integer,
    "status" text not null check("status" in ('pending', 'accepted')),
    Primary Key ("user_id", "connected_user_id"),
    Foreign Key ("user_id") References "users"("id") ON DELETE CASCADE,
    Foreign Key ("connected_user_id") References "users"("id") ON DELETE CASCADE
);

CREATE TABLE "events" (
    "id" INTEGER,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "city_id" INTEGER NOT NULL,
    "host_id" INTEGER NOT NULL,
    "event_time" NUMERIC NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("city_id") REFERENCES "city"("id") ON DELETE CASCADE,
    FOREIGN KEY("host_id") REFERENCES "users"("id") ON DELETE CASCADE
);
