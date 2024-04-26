from opensuse/tumbleweed:latest
# install kanidm, postgres, postgres extensions, supervisor & patroni
RUN zypper -n install kanidm-unixd-clients postgresql16-server postgresql16-contrib supervisor python312-pipx && zypper -n clean
RUN PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx install 'patroni[psycopg3,consul]'

# Set up kanidm & postgres dirs with working defaults
RUN mkdir /var/{cache,lib,run}/kanidm-unixd /pg /data
RUN chown postgres /var/{cache,lib,run}/kanidm-unixd /pg /data
RUN chmod o-rwx /var/{cache,lib,run}/kanidm-unixd /pg /data

ADD supervisord.conf /etc/supervisord.conf

# Strip default PAM config, inject kanidm-unixd only for postgres
RUN rm /etc/pam.d/*
ADD pam.d /etc/pam.d
ADD nsswitch.conf /etc/nsswitch.conf
ADD entrypoint.sh /

#ENV RUST_LOG=kanidm=debug

ENTRYPOINT ["/entrypoint.sh"]
