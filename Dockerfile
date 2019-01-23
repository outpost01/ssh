FROM ubuntu

ENV LANG C.UTF-8

RUN apt-get update

RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

EXPOSE 22

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ADD config /root/.ssh/config


RUN apt-get install -y \
ffmpeg \
libmagic-dev \
python3 \
curl \
tar

RUN curl -L -o EFB-latest.tar.gz \
$(curl -s https://api.github.com/repos/blueset/ehForwarderBot/tags \
| grep tarball_url | head -n 1 | cut -d '"' -f 4) \
&& mkdir -p /opt/ehForwarderBot/storage \
&& tar -xzf EFB-latest.tar.gz --strip-components=1 -C /opt/ehForwarderBot \
&& rm EFB-latest.tar.gz \
&& pip3 install -r /opt/ehForwarderBot/requirements.txt \
&& rm -rf /root/.cache

RUN apt-get clean &&\
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/entrypoint.sh"]
