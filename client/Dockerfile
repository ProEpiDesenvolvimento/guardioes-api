# base image
FROM node:10-alpine

# set working directory
RUN mkdir -p /usr/src/frontend
WORKDIR /usr/src/frontend

# add `/usr/src/frontend/node_modules/.bin` to $PATH
ENV PATH /usr/src/frontend/node_modules/.bin:$PATH

# install and cache app dependencies
COPY package.json /usr/src/frontend/package.json
RUN yarn install
RUN yarn global add react-scripts@1.1.1

# start app
CMD ["yarn", "start"]
