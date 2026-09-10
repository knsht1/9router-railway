FROM decolua/9router:0.5.69

# 9router's own Dockerfile already sets PORT/HOSTNAME as ENV defaults and
# handles volume permissions correctly at container start (its entrypoint
# chowns /app/data to the non-root `node` user before dropping privileges),
# so no USER root workaround is needed here, unlike several other templates
# in this project. Still setting PORT explicitly below as a Railway variable
# (not just relying on the image's own Dockerfile default) - a Dockerfile-only
# default has already been proven insufficient for Railway's own edge routing
# on other templates in this collection (Metabase, Postiz, Vaultwarden).
ENV PORT=20128
ENV HOSTNAME=0.0.0.0
ENV DATA_DIR=/app/data

EXPOSE 20128
