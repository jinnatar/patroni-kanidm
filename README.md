### patroni & kanidm-unixd combined for PAM auth.

Things you definitely need to do:
- Volume mount in `/etc/kanidm` to configure kanidm upstream
- Volume mount in the postgres data dir at `/data`. The data dir should be chowned `497:497`
- Volume mount in a patroni config at `/secrets/patroni.yaml`. An example with PAM auth is provided in `example_patroni.yaml`, it will not work without modification.
