FROM node:16.17.0-alpine as builder
WORKDIR /app
COPY ./package.json .
# yarn.lock is used to lock the version of the dependecy that have been mentioned in the package.json
COPY ./yarn.lock . 
RUN yarn install
COPY . .
ARG TMDB_V3_API_KEY
ENV VITE_APP_TMDB_V3_API_KEY=${TMDB_V3_API_KEY}
ENV VITE_APP_API_ENDPOINT_URL="https://api.themoviedb.org/3"
RUN yarn build

FROM nginx:stable-alpine
# usr/share/nginx == data files 
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=builder /app/dist .
EXPOSE 80
# the nginx will run on the foreground and not on the daemon of the background
ENTRYPOINT ["nginx", "-g", "daemon off;"]
