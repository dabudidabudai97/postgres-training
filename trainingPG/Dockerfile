FROM golang:1.27.1-alpine3.24 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go build -o ./run .

FROM alpine:3.24
RUN apk --no-cache add ca-certificates
WORKDIR /root/

COPY --from=builder /app/run .

EXPOSE 8080
CMD ["./run"]