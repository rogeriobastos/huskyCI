FROM golang:1.15
WORKDIR /go/src/app
COPY api/ .
RUN CGO_ENABLED=0 go build -o huskyci-api server.go

FROM debian:stable-slim
RUN useradd huskyci
USER huskyci
WORKDIR /app
COPY --from=0 /go/src/app/huskyci-api ./
EXPOSE 8888
CMD ["/app/huskyci-api"]
