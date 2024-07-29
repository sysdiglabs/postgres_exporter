FROM golang:1.20.4 AS base
ARG VERSION
ARG GIT_COMMIT
ARG DATE
ARG TARGETARCH

WORKDIR /go/src/github.com/prometheus-community/postgres_exporter

FROM base AS builder
COPY . .
RUN go mod tidy
RUN make build
RUN cp postgres_exporter /bin/postgres_exporter

FROM scratch AS scratch
COPY --from=builder /bin/postgres_exporter /bin/postgres_exporter
EXPOSE     9187
USER       59000:59000
ENTRYPOINT [ "/bin/postgres_exporter" ]

FROM quay.io/sysdig/sysdig-mini-ubi9:1.3.5 AS ubi
COPY --from=builder /bin/postgres_exporter /bin/postgres_exporter
EXPOSE     9187
USER       59000:59000
ENTRYPOINT [ "/bin/postgres_exporter" ]