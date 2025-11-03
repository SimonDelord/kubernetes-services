FROM alpine:latest
MAINTAINER	simon

RUN apk add --update python3 python3-dev py-pip build-base 
RUN pip install virtualenv 
RUN rm -rf /var/cache/apk/*


ENV UDPPORT 5005
ADD udplistener.py /udplistener.py
CMD ["python", "-u","/udplistener.py"]

EXPOSE ${UDPPORT}
EXPOSE ${UDPPORT}/udp
