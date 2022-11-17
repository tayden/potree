ARG VERSION=16
FROM node:$VERSION as build-deps

WORKDIR /app

# Install dependencies
COPY package.json package-lock.json gulpfile.js rollup.config.js LICENSE ./
COPY src ./src
COPY libs ./libs
COPY resources ./resources
COPY examples ./examples

# Install from lockfile
RUN npm ci

FROM nginx:latest

ENV PORT=80

# Serve the build directory on Nginx
COPY --from=build-deps /app/build /usr/share/nginx/html/build
COPY libs /usr/share/nginx/html/libs
COPY static /usr/share/nginx/html/static

COPY nginx/templates /etc/nginx/templates

# Better setup for more scenes
#COPY showcase /usr/share/nginx/html/showcase
#COPY index.html /usr/share/nginx/html/index.html
#RUN rm /usr/share/nginx/html/index.html

COPY showcase/joffre.html /usr/share/nginx/html/index.html
RUN sed -i 's/\.\./potree/g' /usr/share/nginx/html/index.html
