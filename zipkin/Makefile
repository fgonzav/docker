VERSION?=1.0
TAG?=zipkin:$(VERSION)

run-dev:
	java -jar ./zipkin.jar

build-image:
	docker build -t $(TAG) .

run: build-image
	docker run -d --name zipkin -p 9411:9411 --rm $(TAG)

create: build-image
	kubectl create -f k8s/zipkin.yml

create-svc:
	kubectl create -f k8s/zipkin-svc.yml

redeploy: build-image
	kubectl delete pods -l app=zipkin

stop:
	docker stop zipkin
