VERSION ?= 1.0.0

build:
	docker build --file=dockerfile --no-cache --tag=aviatrix/avx-new-relic:${VERSION} .

clean:
	docker container rm $$(docker stop $$(docker ps -a -q)); docker rmi -f $$(docker images -qa aviatrix/avx-new-relic); docker system prune -af

push:
	docker push aviatrix/avx-new-relic:${VERSION}

run:
	docker run -d \
		-e CPLT_API_KEY=$$CPLT_API_KEY \
		-e CPLT_DOMAIN=$$CPLT_DOMAIN \
		-e NRIA_LICENSE_KEY=$$NRIA_LICENSE_KEY \
	    -e NRIA_LOG_LEVEL=trace \
		aviatrix/avx-new-relic:${VERSION}

run-debug:
	docker run \
		-e CPLT_API_KEY=$$CPLT_API_KEY \
		-e CPLT_DOMAIN=$$CPLT_DOMAIN \
		-e NRIA_LICENSE_KEY=$$NRIA_LICENSE_KEY \
	    -e NRIA_LOG_LEVEL=trace \
		aviatrix/avx-new-relic:${VERSION}

run-latest:
	docker run -d \
		-e CPLT_API_KEY=$$CPLT_API_KEY \
		-e CPLT_DOMAIN=$$CPLT_DOMAIN \
		-e NRIA_LICENSE_KEY=$$NRIA_LICENSE_KEY \
	    -e NRIA_LOG_LEVEL=trace \
		aviatrix/avx-new-relic:latest

release:
	docker tag aviatrix/avx-new-relic:${VERSION} aviatrix/avx-new-relic:latest
	docker push aviatrix/avx-new-relic:latest
