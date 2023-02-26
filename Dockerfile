FROM --platform=linux/amd64 node:19.7-slim

COPY . .

RUN npm install

EXPOSE 3000

CMD [ "npm", "start" ]