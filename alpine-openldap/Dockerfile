FROM alpine:3.12

USER root
WORKDIR /root
#EXPOSE 636
EXPOSE 389

RUN apk add --update openldap=2.4.50-r0 openldap-back-mdb=2.4.50-r0 && rm -rf /var/cache/apk/*

COPY scripts/* /root/
COPY ldif/* /etc/openldap/
COPY conf/slapd.conf /etc/openldap/slapd.conf

RUN mkdir /run/openldap 2> /dev/null
RUN chmod u+x /root/docker-entrypoint.sh /root/configuration

ENTRYPOINT [ "/root/docker-entrypoint.sh" ]
#ENTRYPOINT ["tail", "-f", "/dev/null"]