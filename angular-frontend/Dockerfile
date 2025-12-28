# Build stage
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Build Angular app
RUN npm run build --configuration=production

# Runtime stage
FROM nginx:alpine

# Install envsubst (gettext package contains envsubst)
RUN apk add --no-cache gettext

# Copy built app
COPY --from=builder /app/dist/angular-frontend /usr/share/nginx/html

# Copy the nginx template
COPY nginx/default.conf.template /etc/nginx/conf.d/default.conf.template

# Copy the Angular environment template
COPY src/assets/env.js.template /usr/share/nginx/html/assets/env.js.template

EXPOSE 80

# Copy and set up entrypoint
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]