FROM docker.io/library/debian:stable
COPY ./qq.deb /tmp/qq.deb
COPY ./run_in_image.sh /usr/local/bin/run.sh
RUN useradd -u 1000 -m user && \
     chmod 755 /usr/local/bin/run.sh && \
     apt update && \
     apt install --no-install-recommends -y \
     libgbm1 \
     libasound2 \
     libunwind8 \
     libnotify-bin \
     libssh2-1t64 \
     libnss3 \
     locales \
     fonts-noto-color-emoji \
     fonts-noto-cjk \
     libcurl4 \
     libopengl0 \
     /tmp/qq.deb && \
     sed -i '/^#.* zh_CN.UTF-8 /s/^#//' /etc/locale.gen && locale-gen && \
     ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
     DEBIAN_FRONTEND=noninteractive dpkg-reconfigure --frontend noninteractive tzdata && \
     fc-cache -fv && \
     printf '#!/usr/bin/bash\nprintf "$@" | tee /home/user/url.txt' | tee /usr/local/bin/xdg-open && \
     chmod 0755 /usr/local/bin/xdg-open && \
     rm /opt/QQ/resources/app/libssh2.so.1 && \
     rm /opt/QQ/resources/app/libunwind* && \
     rm /opt/QQ/resources/app/resource/fonts/AppleColorEmoji*.ttf && \
     ln -s /usr/share/fonts/truetype/noto/NotoColorEmoji.ttf /opt/QQ/resources/app/resource/fonts/AppleColorEmoji.ttf && \
     ln -s /usr/share/fonts/truetype/noto/NotoColorEmoji.ttf /opt/QQ/resources/app/resource/fonts/AppleColorEmoji-fix.ttf && \
     rm -rf /var/lib/apt/lists/* && \
     rm -rf /tmp/* && \
     rm -rf /var/tmp/*
ENV PATH="/usr/local/bin:${PATH}"
USER user
ENTRYPOINT ["bash", "-c", "/usr/local/bin/run.sh"]