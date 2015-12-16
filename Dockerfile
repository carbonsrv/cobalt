#####################
# Cobalt Dockerfile #
#####################

FROM carbonsrv/carbon:v1.2.1

MAINTAINER Adrian "vifino" Pistol

# Make /pwd a volume, so you can bind it
VOLUME ["/pwd"]
WORKDIR /pwd

# Put the source in that directory.
COPY . /cobalt

# Run cobalt
ENTRYPOINT ["/go/bin/carbon", "-root=/cobalt", "-config=/cobalt/cobalt.conf", "/cobalt/cobalt.lua"]
CMD ["settings.lua"]