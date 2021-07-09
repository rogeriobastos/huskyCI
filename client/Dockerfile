FROM golang:1.16
WORKDIR /go/src/app
COPY . .
RUN cd cmd && go build -o huskyci-client main.go

FROM debian:stable-slim
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates
RUN useradd huskyci
USER huskyci
WORKDIR /app
COPY --from=0 /go/src/app/cmd/huskyci-client ./
CMD ["/app/huskyci-client"]
