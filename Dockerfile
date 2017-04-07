# shadowsocks-net-speeder

FROM ubuntu:16.04
MAINTAINER Iniv
RUN apt-get update && \
    apt-get install -y python-pip libnet1 libnet1-dev libpcap0.8 libpcap0.8-dev git

RUN pip install git+https://github.com/shadowsocks/shadowsocks.git@master

RUN git clone https://github.com/snooda/net-speeder.git net-speeder
WORKDIR net-speeder
RUN sh build.sh

RUN mv net_speeder /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/net_speeder

ENV S_PORT:$PORT
ENV S_PASSWORD:$PASSWORD
ENV S_METHOD:$METHOD
RUN sudo ssserver -p S_PORT -k S_PASSWORD -m S_METHOD

# Configure container to run as an executable
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
