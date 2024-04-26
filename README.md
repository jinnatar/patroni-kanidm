### patroni & kanidm-unixd combined for PAM auth.

#### Kanidm config

Either mount in `/etc/kanidm` config files or configure via environment variables: 
- `KANIDM_URI` - The default value of `false` leaves management of /etc/kanidm/config to you, anything else is interpreted as the IDM URI.
- `KANIDM_VERIFY_CA` - By default `true`, set to `false` to disable CA verification. Any prod deployment should be `true`.
- `KANIDM_ALLOWED_GROUP` - The default value of `false` leaves management of /etc/kanidm/unixd to you. IDM group that gates access to PostgreSQL. Must be POSIX enabled.
- `KANIDM_UNIXD_DEBUG` - Enable kanidm-unixd debug logging. Default `false`.
- `KANIDM_PAM_DEBUG` - Enable pam_kanidm.so debug logging. Default `false`.

#### Patroni & PostgreSQL config

- Volume mount in the postgres data dir at `/data` or override the location with env variable `PGDATA`. The data dir should be chowned `497:497`.
- Volume mount in a patroni config at `/secrets/patroni.yaml`. An example with PAM auth is provided in `example_patroni.yaml`, it will not work without modification.
