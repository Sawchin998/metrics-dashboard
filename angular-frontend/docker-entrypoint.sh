#!/bin/sh

# Default API URL
: "${API_BASE_URL:=http://rails-api:3000}"

# Remove trailing slash to prevent Nginx errors
API_BASE_URL="${API_BASE_URL%/}"

echo "Using API_BASE_URL=$API_BASE_URL"

# Replace Angular env.js
envsubst '${API_BASE_URL}' \
  < /usr/share/nginx/html/assets/env.js.template \
  > /usr/share/nginx/html/assets/env.js

# Replace Nginx config - use the template file
envsubst '${API_BASE_URL}' \
  < /etc/nginx/conf.d/default.conf.template \
  > /etc/nginx/conf.d/default.conf

# Start Nginx
exec nginx -g 'daemon off;'