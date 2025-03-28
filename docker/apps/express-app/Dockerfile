FROM node:18-alpine
WORKDIR /app
COPY . .
RUN npm install
ENV APP_VERSION="dev"
CMD ["node", "index.js"]
