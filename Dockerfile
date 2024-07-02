FROM node:20

WORKDIR /app

COPY package*.json ./

RUN npm install express --save

COPY . .

ENV PORT=8080

EXPOSE 8080

CMD ["node", "."]
