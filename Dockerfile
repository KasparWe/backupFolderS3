FROM alpine:3.9 

# install requirements

ADD install.sh install.sh
RUN sh install.sh && rm install.sh

ENV SCHEDULE=**None**

ENV TARGET_DIR=/backup/
ENV SOURCE_DIR=/data/

# bucket/path/to/place/
ENV S3_BUCKET=**None**
ENV S3_REGION=**None**
ENV S3_ACCESS_KEY_ID=**None**
ENV S3_SECRET_ACCESS_KEY=**None**
ENV S3_S3V4 no
ENV S3_ENDPOINT=**None**

ENV UPLOAD_LATEST=false
ENV ADD_TIMESTAMP=true

VOLUME $TARGET_DIR
VOLUME $SOURCE_DIR

ADD run.sh run.sh
ADD backup.sh backup.sh

CMD ["sh", "run.sh"]

