FROM alpine AS builder
RUN mkdir /out && echo "<h1>mrc - gebaut am $(date)</h1> durch marpx" > /out/index.html

FROM nginx:alpine
COPY --from=builder /out/index.html /usr/share/nginx/html/index.html