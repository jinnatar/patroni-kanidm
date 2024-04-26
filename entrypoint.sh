#!/bin/bash

set -eu

# Kanidm specific
KANIDM_URI="${KANIDM_URI:-false}" # default disables kanidm config generation
KANIDM_VERIFY_CA="${KANIDM_VERIFY_CA:-true}" # default verify CA
KANIDM_ALLOWED_GROUP="${KANIDM_ALLOWED_GROUP:-false}" # default disables unixd config generation
KANIDM_UNIXD_DEBUG="${KANIDM_UNIXD_DEBUG:-false}" # default: no debug enabled
KANIDM_PAM_DEBUG="${KANIDM_PAM_DEBUG:-false}" # default: no debug enabled

# Postgres
PGDATA="${PGDATA:-/data}"

# Actions based on the values above
[[ "$KANIDM_UNIXD_DEBUG" != "false" ]] && export RUST_LOG="kanidm=debug"

if [[ "$KANIDM_PAM_DEBUG" != "false" ]]; then
	sed -i -e 's/pam_kanidm.so ignore_unknown_user$/pam_kanidm.so ignore_unknown_user,debug/' /etc/pam.d/postgresql
fi

mkdir -p /etc/kanidm

if [[ "$KANIDM_URI" != "false" ]]; then
	cat <<EOT >> /etc/kanidm/config
uri = "${KANIDM_URI}"
verify_ca = ${KANIDM_VERIFY_CA}
EOT
else
	2>&1 echo "KANIDM_URI not defined, assuming /etc/kanidm/config is configured elsewhere"
fi
if [[ "$KANIDM_ALLOWED_GROUP" != "false" ]]; then
	cat <<EOT >> /etc/kanidm/unixd
pam_allowed_login_groups = ["${KANIDM_ALLOWED_GROUP}"]
EOT
else
	2>&1 echo "KANIDM_ALLOWED_GROUP not defined, assuming /etc/kanidm/unixd is configured elsewhere"
fi

chown postgres:postgres /etc/kanidm
chown :postgres /etc/kanidm/*
chmod 0440 /etc/kanidm/*

exec supervisord -c /etc/supervisord.conf $@
