FROM alpine:edge
RUN apk --no-cache add vsftpd
COPY vsftpd.sh /usr/local/bin/
COPY vsftpd.conf /etc/vsftpd/
EXPOSE 21 21000-21010
CMD ["vsftpd.sh"]
