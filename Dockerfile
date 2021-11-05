ARG bash_version=5.1.0-r0
ARG libxml2_version=2.9.12-r0
ARG image_name=alpine
ARG image_tag=3.13.6

FROM $image_name:$image_tag

ARG bash_version
ARG libxml2_version

RUN apk --no-cache add libxml2-utils=$libxml2_version bash=$bash_version

WORKDIR /data
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
