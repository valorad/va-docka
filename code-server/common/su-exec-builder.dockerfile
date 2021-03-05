FROM debian:buster AS su-exec-builder

# Install latest su-exec
RUN  set -ex; \
     apt update; \
     apt install -y curl; \
     curl -o /usr/local/bin/su-exec.c https://raw.githubusercontent.com/ncopa/su-exec/master/su-exec.c; \
     fetch_deps='gcc libc-dev'; \
     apt install -y --no-install-recommends $fetch_deps; \
     rm -rf /var/lib/apt/lists/*; \
     gcc -Wall /usr/local/bin/su-exec.c -o/usr/local/bin/su-exec; \
     chown root:root /usr/local/bin/su-exec; \
     chmod 0755 /usr/local/bin/su-exec; \
     rm /usr/local/bin/su-exec.c; \
     apt purge -y --auto-remove $fetch_deps;

# Dependant container: Install su-exec
# COPY --from=su-exec-builder /usr/local/bin/su-exec /usr/local/bin/