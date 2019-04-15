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
        bash \
        ruby

RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && \
    tar --strip-components=1 -xvf install-tl-unx.tar.gz && \
    ./install-tl --profile=texlive.profile && \
    cd && rm -rf /tmp/install-tl-unx

ENV PATH="/usr/local/texlive/2018/bin/x86_64-linuxmusl:${PATH}"

# Install additional packages from CTAN.
RUN tlmgr update --self && \
    tlmgr install \
      # PGF/TikZ/other graphical stuff.
      pgf \
      xcolor \
      varwidth \
      standalone \
      xkeyval \
      etoolbox \
      tikzpeople \
      xstring \
      pgfopts\
      # Fonts and Russian handling.
      ec \
      lh \
      abstract \
      cyrillic \
      hyphen-russian \
      babel-russian && \
   # Update fonts and formats.
    fmtutil-sys --all && \
    mktexmf larm1095 && \
    mktexmf larm1440 && \
    mktexmf labx1440 && \
    mktexmf larm1200 && \
    mktexmf labx1200 && \
    mktexmf latt1200 && \
    mktexmf larm0900 && \
    mktexmf labx0900 && \
    mktexmf labx1095 && \
    mktexmf larm1000 && \
    mktexmf larm0800 && \
    mktexmf larm0600 && \
    mktexmf lati1095 && \
    mktexmf latt1095 && \
    mktextfm larm1095 && \
    mktextfm larm1440 && \
    mktextfm labx1440 && \
    mktextfm larm1200 && \
    mktextfm labx1200 && \
    mktextfm latt1200 && \
    mktextfm larm0900 && \
    mktextfm labx0900 && \
    mktextfm labx1095 && \
    mktextfm larm1000 && \
    mktextfm larm0800 && \
    mktextfm larm0600 && \
    mktextfm lati1095 && \
    mktextfm latt1095 && \
    # Clean up unneeded packages.
    apk del wget xz tar && \
    rm -rf /var/cache/apk/ && mkdir /var/cache/apk/ && \
    rm -rf /usr/share/man

# Install additional packages manually.
RUN mkdir /tmp/lib
WORKDIR /tmp/lib
COPY lib .
RUN TEXLIB="$(kpsewhich -var-value=TEXMFHOME)/tex/latex" && \
    mkdir -p $TEXLIB && \
    cp * $TEXLIB

RUN mkdir /workdir

WORKDIR /workdir

VOLUME ["/workdir"]
