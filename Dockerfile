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
    curl \
    ca-certificates \
    cron \
    vim-tiny \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# --- Enable Apache modules ---
RUN a2enmod dav dav_fs ssl auth_basic

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
</VirtualHost>" > /etc/apache2/sites-available/webdav.conf

RUN a2dissite 000-default.conf \
 && a2ensite webdav.conf

# --- Expose ports ---
EXPOSE ${WEBDAV_PORT} ${SSH_PORT}

# --- Entry script ---
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY sync.sh /usr/local/bin/sync.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/sync.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
