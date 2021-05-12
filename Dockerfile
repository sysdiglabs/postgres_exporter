FROM golang:1.16 as base
ARG VERSION
ARG GIT_COMMIT
ARG DATE
ARG TARGETARCH

WORKDIR /go/src/github.com/prometheus-community/postgres_exporter

FROM base as builder
COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./
COPY cmd ./cmd
COPY .promu.yml .promu.yml
COPY Makefile Makefile
COPY Makefile.common Makefile.common
RUN make build
RUN cp postgres_exporter /bin/postgres_exporter

FROM scratch
COPY --from=builder /bin/postgres_exporter /bin/postgres_exporter
EXPOSE     9187
USER       nobody
ENTRYPOINT [ "/bin/postgres_exporter" ]