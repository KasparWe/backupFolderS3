# Directory backup to S3
Backups a directory to S3 after gzipping it.

You can set the cron via `SCHEDULE` environment variable.
eg. @daily

You just need to fill out the variables in the docker-compose.yml
(you may need to copy the example file)

Following environemnt variables should be set for backup to work:
```
S3_BUCKET=		// no trailing slash at the end!
S3_REGION=
S3_ACCESS_KEY_ID=
S3_SECRET_ACCESS_KEY=
S3_FILENAME=
S3_ENDPOINT= 	// you can set your api origin here (eg. DigitalOcean)
SOURCE_DIR=
TARGET_DIR=
SCHEDULE=
```
