SITE_URL := lauraingrammusic.co.uk

all:

run:
	hugo server -D --disableFastRender

init:
	cd terraform && terraform init && terraform apply

build:
	rm -fr public/*
	hugo

deploy:
	aws s3 sync public s3://${SITE_URL} --delete --acl public-read

update: build deploy

analytics:
	@aws s3 ls logs.${SITE_URL}/$(shell date '+%Y-%m') \
		| awk '{print $$4}' \
		| xargs -P10 -I {} aws s3 cp s3://logs.${SITE_URL}/{} - \
		| grep WEBSITE.GET.OBJECT \
		| grep .html \
		| awk '{print $$9}' \
		| sort \
		| uniq -c