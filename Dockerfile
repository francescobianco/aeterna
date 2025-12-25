# --- Base image ---
FROM debian:stable-slim

# --- Metadata ---
LABEL maintainer="Francesco <tuo@email.com>"
LABEL description="Nodo Aeterna: WebDAV + rsync for distributed survivability"

# --- Install dependencies ---
RUN apt-get update && apt-get install -y \
    apache2 \
    rsync \
    openssh-client \
    openssh-server \
    curl \
    ca-certificates \
    cron \
    vim-tiny \
 && apt-get clean && rm -rf /var/lib/apt/lists/*


RUN touch /var/log/auth.log && chmod 644 /var/log/auth.log
RUN sed -i 's/^#*LogLevel.*/LogLevel DEBUG3/' /etc/ssh/sshd_config \
 && sed -i 's/^#*SyslogFacility.*/SyslogFacility AUTH/' /etc/ssh/sshd_config

RUN mkdir -p /var/run/sshd

RUN useradd -m -s /bin/bash replica
RUN groupadd aeterna-sync
RUN usermod -aG aeterna-sync replica
RUN usermod -aG aeterna-sync www-data
RUN mkdir -p /home/replica/.ssh
RUN chown -R replica:replica /home/replica/.ssh
RUN touch /home/replica/.ssh/authorized_keys
RUN chown -R replica:aeterna-sync /home/replica/.ssh
RUN chmod 750 /home/replica/.ssh
RUN chmod 640 /home/replica/.ssh/authorized_keys


# --- Enable Apache modules ---
RUN a2enmod dav dav_fs ssl auth_basic
RUN a2enmod cgi

# --- Directories ---
VOLUME ["/var/lib/aeterna"]
WORKDIR /var/lib/aeterna

# --- Environment variables ---
ENV NODE_ID="aeterna-node-1"
ENV WEBDAV_USER="aeterna"
ENV WEBDAV_PASS="Secret1234!"
ENV WEBDAV_PORT=80
ENV SSH_PORT=22


RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf


# --- Setup WebDAV user ---
RUN htpasswd -cb /etc/apache2/webdav.passwd $WEBDAV_USER $WEBDAV_PASS

# --- Apache WebDAV config ---
RUN echo "\
<VirtualHost *:${WEBDAV_PORT}>\n\
    DocumentRoot /var/lib/aeterna/data\n\
\n\
    # Configurazione WebDAV\n\
    <Directory /var/lib/aeterna/data>\n\
        DAV On\n\
        AuthType Basic\n\
        AuthName 'Aeterna WebDAV'\n\
        AuthUserFile /etc/apache2/webdav.passwd\n\
        Require valid-user\n\
        Options Indexes FollowSymLinks\n\
        AllowOverride None\n\
        Require all granted\n\
    </Directory>\n\
\n\
    # Configurazione CGI per update_keys\n\
    Alias /_api/ /opt/aeterna/_api/\n\
    <Directory /opt/aeterna/_api>\n\
        Options +ExecCGI\n\
        AddHandler cgi-script .sh\n\
        AuthType Basic\n\
        AuthName 'Aeterna WebDAV'\n\
        AuthUserFile /etc/apache2/webdav.passwd\n\
        Require valid-user\n\
    </Directory>\n\
</VirtualHost>" > /etc/apache2/sites-available/webdav.conf

RUN a2dissite 000-default.conf \
 && a2ensite webdav.conf

# --- Expose ports ---
EXPOSE ${WEBDAV_PORT} ${SSH_PORT}

# --- Entry script ---
COPY bin/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY bin/sync.sh /usr/local/bin/sync.sh
COPY bin/update.sh /usr/local/bin/update.sh
COPY bin/await.sh /usr/local/bin/await.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/sync.sh
RUN chmod +x /usr/local/bin/update.sh
RUN chmod +x /usr/local/bin/await.sh

COPY _api /opt/aeterna/_api
RUN chmod +x -R /opt/aeterna/_api/*.sh

COPY crontab /var/spool/cron/crontabs/replica
RUN crontab -u replica /var/spool/cron/crontabs/replica

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
