FROM golang:1.27.1-alpine3.24 AS builder

RUN CGO_ENABLED=0 go install \
    -tags='no_mysql no_sqlite3 no_mssql no_clickhouse no_ydb no_vertica no_azuresql' \
    github.com/pressly/goose/v3/cmd/goose@v3.27.3

FROM alpine:3.24

RUN apk --no-cache add ca-certificates
COPY --from=builder /go/bin/goose /usr/local/bin/goose

ENTRYPOINT ["goose"]
