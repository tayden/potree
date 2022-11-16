ARG VERSION=16
FROM node:$VERSION as build-deps

WORKDIR /app

# Install dependencies
COPY . .
RUN npm install

FROM nginx:latest

# Serve the build directory on Nginx
COPY --from=build-deps /app/build /usr/share/nginx/html/build
COPY libs /usr/share/nginx/html/libs
COPY examples /usr/share/nginx/html/examples
COPY examples/joffre.html /usr/share/nginx/html/index.html
COPY static /usr/share/nginx/html/static

COPY nginx/templates /etc/nginx/templates
