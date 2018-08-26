## Development

### Docker build for dev.
- `docker build -f dev.Dockerfile -t farhan687/reactapp .`

### Docker run with auto reload
- `docker run -v /app/node_modules -v $(pwd):/app -p 3123:3000 farhan687/reactapp`

### Forget above codes with use of docker-compose

```yml
  reactapp:
    build:
      context: .
      dockerfile: dev.Dockerfile
    ports:
      - "3000:3000"
    volumes:
      - /app/node_modules
      - .:/app
    
```

and just run

`docker-compose up`

now, in this case we can remove `COPY . .` from dev.Dockerfile because we are referencing the whole dir. in /app

### Run test cases
`docker exec -it ${dockerid} npm run test`

### Forget above commands with use of docker-compose

We can add one more service which will run in another container just for tests

```yml
  reacttest:
    build:
      context: .
      dockerfile: dev.Dockerfile
    volumes:
      - /app/node_modules
      - .:/app
    command: ["npm", "run", "test"]
```


and just run

`docker-compose up --build`

## Production

- We will use `nginx` for production.
- Our flow will be - build the app and copy the content to nginx container

Following code is in dockerfile

### build app and copy to nginx contnainer

```Dockerfile
FROM node:alpine as builder
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

FROM nginx
COPY --from=builder /app/build /usr/share/nginx/html
```