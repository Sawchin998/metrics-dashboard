# angular-frontend/Dockerfile

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

# Copy built app
COPY --from=builder /app/dist/angular-frontend /usr/share/nginx/html

# Simple nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]