FROM alpine:3.8

RUN mkdir /tmp/install-tl-unx

WORKDIR /tmp/install-tl-unx

COPY texlive.profile .

RUN apk --no-cache add \
        perl \
        wget \
        xz \
        tar \
        make \
        git \
        poppler-utils \
        bash

RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && \
    tar --strip-components=1 -xvf install-tl-unx.tar.gz && \
    ./install-tl --profile=texlive.profile && \
    cd && rm -rf /tmp/install-tl-unx


ENV PATH="/usr/local/texlive/2018/bin/x86_64-linuxmusl:${PATH}"

# Install additional packages
RUN tlmgr update --self && \
    tlmgr install \
      # PGF/TikZ/other graphical stuff.
      pgf \
      xcolor \
      varwidth \
      standalone \
      xkeyval \
      # Fonts and Russian handling.
      ec \
      lh \
      abstract \
      cyrillic \
      babel-russian && \
    # clean up unneeded packages
    apk del wget xz tar && \
    rm -rf /var/cache/apk/ && mkdir /var/cache/apk/ && \
    rm -rf /usr/share/man && \
    mkdir /workdir

WORKDIR /workdir

VOLUME ["/workdir"]

