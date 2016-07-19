FROM msaraiva/elixir:1.3.0

MAINTAINER sergiobuj

RUN apk --update add \
  erlang-asn1 \
  erlang-crypto \
  erlang-dev \
  erlang-erl-interface \
  erlang-eunit\
  erlang-inets \
  erlang-parsetools \
  erlang-public-key \
  erlang-ssl \
  erlang-syntax-tools \
  erlang-tools \
  erlang-xmerl \
  git && rm -rf /var/cache/apk/*

RUN git config --global url."https://github.com/".insteadOf "git@github.com:"

CMD ["mix"]
