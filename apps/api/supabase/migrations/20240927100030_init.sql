-- TABLES

-- https://supabase.com/docs/guides/database/postgres/custom-claims-and-role-based-access-control-rbac?queryGroups=language&language=plpgsql

-- Custom types
create type public.app_role as enum ('admin', 'class');

-- USER ROLES
create table public.user_roles
(
  id      uuid                                         not null default gen_random_uuid(),
  user_id uuid references auth.users on delete cascade not null,
  role    app_role                                     not null,
  unique (user_id, role),
  constraint user_roles_pkey primary key (id)
);
comment
  on table public.user_roles is 'Application roles for each user.';

