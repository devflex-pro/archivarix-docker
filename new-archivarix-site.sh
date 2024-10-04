#!/bin/bash

DOMAIN=$1
EMAIL=$2

if [ -z "$DOMAIN" ] || [ -z "$EMAIL" ]; then
    echo "Usage: $0 <DOMAIN> <EMAIL>"
    exit 1
fi

DOCKER_COMPOSE_FILE="docker-compose.yml"


if grep -q "archivarix_$DOMAIN" "$DOCKER_COMPOSE_FILE"; then
    echo "Archivarix service for $DOMAIN already exists in the Docker Compose file."
else
    echo "Adding Archivarix service for $DOMAIN to the Docker Compose file..."
    cat <<EOL >> "$DOCKER_COMPOSE_FILE"

  archivarix_$DOMAIN:
    image: devflexpro:archivarix-cms
    container_name: archivarix_$DOMAIN
    volumes:
      - ./www/$DOMAIN:/var/www/html
    networks:
      - wp-network
    restart: always
EOL
fi


# Создание конфигурации Nginx для домена
echo "Creating Nginx configuration for $DOMAIN..."
cat <<EOL > ./nginx_conf/conf.d/$DOMAIN.conf
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;
    return 301 https://$DOMAIN\$request_uri;
}

server {
    listen 443 ssl;
    server_name $DOMAIN www.$DOMAIN;

    root /var/www/html;
    index index.php index.html index.htm;

    ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass archivarix_$DOMAIN:9000;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }

    location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
        expires max;
        log_not_found off;
    }
}
EOL

# Остановка контейнера Nginx, чтобы освободить порты 80 и 443 
docker stop nginx

# Получение SSL-сертификата через Certbot в контейнере
echo "Requesting SSL certificate..."
docker run -it --rm --name certbot \
  -p 80:80 \
  -p 443:443 \
  -v "./nginx_conf/letsencrypt:/etc/letsencrypt" \
  certbot/certbot certonly --standalone -d $DOMAIN --email $EMAIL --agree-tos --non-interactive

# Перезапуск Nginx для применения сертификатов
echo "Restarting Nginx container to apply SSL certificatesand up new Wordpress container for $DOMAIN"
docker compose up -d

echo "Setup complete for $DOMAIN!"
