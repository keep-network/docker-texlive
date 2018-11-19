FROM alpine:3.8

RUN mkdir /tmp/install-tl-unx

WORKDIR /tmp/install-tl-unx

COPY texlive.profile .

RUN apk --no-cache add \
        perl \
        wget \
        xz \
        tar

RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && \
    tar --strip-components=1 -xvf install-tl-unx.tar.gz && \
    ./install-tl --profile=texlive.profile && \
    apk del perl wget xz tar && \
    cd && rm -rf /tmp/install-tl-unx

ENV PATH="/usr/local/texlive/2018/bin/x86_64-linuxmusl:${PATH}"

# Install additional packages
RUN apk --no-cache add perl wget && \
    tlmgr install collection-latex \
      collection-latexextra \
      collection-langspanish \
      cyrillic \
      amsmath \
      pgf && \
    apk del perl wget

# Install general helpers
RUN apk --no-cache add \
        make \
        git \
        ghostscript \
        bash && \
    rm -rf /var/cache/apk/ && mkdir /var/cache/apk/ && \
    rm -rf /usr/share/man && \
    mkdir /workdir

WORKDIR /workdir

VOLUME ["/workdir"]

