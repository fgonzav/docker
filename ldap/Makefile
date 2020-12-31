NAME=ldap
VERSION?=1.0
TAG?=ldap:$(VERSION)
build-image:
	docker build -t $(TAG) .
run-image:
	docker run -d --name ldap -p 389:389 --rm $(TAG)
run: build-image run-image

create: build-image
	kubectl create -f k8s/ldap.yml

redeploy: build-image
	kubectl delete pods -l app=$(NAME)

stop:
	docker stop $(NAME)