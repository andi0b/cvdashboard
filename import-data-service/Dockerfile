FROM alpine:3

RUN apk add --no-cache postgresql-client tzdata curl

RUN ln -s /usr/share/zoneinfo/Europe/Vienna /etc/localtime && echo "Europe/Vienna" >  /etc/timezone

COPY crontab /etc/crontabs/root
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD sh /entrypoint.sh