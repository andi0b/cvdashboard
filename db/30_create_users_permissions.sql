do
$do$
    begin
        if not EXISTS(
                select
                from pg_catalog.pg_roles -- SELECT list can be empty for this
                where rolname = 'grafana') then
            create user grafana with password 'grafana';
        end if;
    end
$do$;

grant usage on schema public to grafana;
grant select on all tables in schema public to grafana;