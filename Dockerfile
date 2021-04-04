FROM golang:alpine3.13 as builder

ARG ELM_VERSION=0.19.1

RUN apk add curl

RUN curl -L -o elm.gz https://github.com/elm/compiler/releases/download/${ELM_VERSION}/binary-for-linux-64-bit.gz && \
      gunzip elm.gz && \
      chmod +x elm && \
      mv elm /usr/local/bin/

COPY . /code

RUN cd /code && \
      elm make elm/Main.elm --output=server/static/application.js && \
      go build -o /fulla . && \
      chmod +x /fulla

FROM alpine:3.13

COPY --from=builder /fulla /fulla

ENTRYPOINT [ "/fulla" ]