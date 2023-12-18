# builder
FROM golang:1.18-alpine3.17 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o main ./main.go

# development
FROM golang:1.18-alpine3.17 AS development
WORKDIR /app
COPY --from=builder /app/main .
COPY --from=builder /app/go.mod .
COPY --from=builder /app/go.sum .
RUN go install github.com/cosmtrek/air@latest
CMD ["air"]

# production
FROM alpine:3.17 AS production
WORKDIR /app
COPY --from=builder /app/main .
CMD ["/app/main"]
