# Usa una imagen base de Go
#FROM golang:1.23rc1 as builder
FROM golang:1.21 as builder

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia los archivos del repositorio al contenedor
COPY . .

# Compila el binario
RUN go install github.com/anorod/json-log-exporter@latest

# Usa una imagen base mínima de Alpine para la imagen final
FROM alpine:latest

# Para que funcione en Alpine
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

# Copia el binario compilado desde el contenedor builder
COPY --from=builder /go/bin/json-log-exporter /usr/local/bin/json-log-exporter

# Exponer el fichero de configuración
VOLUME /etc/json-log-exporter

# Exponer el directorio de logs
VOLUME /tmp/log

# Exponer el puerto que usa el json-log-exporter
EXPOSE 9321

# Establece el comando por defecto para ejecutar el contenedor
CMD ["json-log-exporter", "-config-file", "/etc/json-log-exporter/config.yml"]
