FROM postgres:13-alpine as base

FROM base as build-r
RUN apk add --update-cache R R-dev R-doc g++
RUN mkdir /rpackages
RUN echo "install.packages('forecast', repos='https://cran.uni-muenster.de', lib='/rpackages')" | R --no-save

FROM base as build-plr
RUN wget https://github.com/postgres-plr/plr/archive/refs/tags/REL8_4_5.tar.gz
RUN tar xzf REL8_4_5.tar.gz
RUN apk add --update-cache R R-dev R-doc clang llvm make
RUN cd plr-REL8_4_5 && USE_PGXS=1 make CPPFLAGS=-DDLSUFFIX=\\\".so\\\" && USE_PGXS=1 DESTDIR=/dist make install

FROM base
RUN apk add --no-cache R
COPY --from=build-r /rpackages /usr/lib/R/library
COPY --from=build-plr /dist /
RUN echo "/lib:/usr/local/lib:/usr/lib:/usr/lib/R/lib" > /etc/ld-musl-x86_64.path

