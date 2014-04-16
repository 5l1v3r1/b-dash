create table users (
  id integer primary key,
  username text,
  email text
);

create table bookmarks (
  id integer primary key,
  user_id integer,
  title text,
  url text,
  created_at text
);
