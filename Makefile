# Registries to push to. Leave off the :5000, as ":" is not 
# handled in makefile names well.
#REGISTRIES = demo.forallsecure.com beta.forallsecure.com
REGISTRIES=beta.forallsecure.com
ACCOUNT=forallsecure

all: build $(REGISTRIES) dockerhub 

build:
	docker build -t lighttpd:vulnerable -f Dockerfile.vulnerable .
	docker build -t lighttpd:fixed -f Dockerfile.fixed .
	docker tag lighttpd:fixed lighttpd:latest

dockerhub: build
	for n in vulnerable fixed latest; do \
		docker tag lighttpd:$$n $(ACCOUNT)/lighttpd:$$n; \
		docker push $(ACCOUNT)/lighttpd:$$n; \
	done

$(REGISTRIES): build
	echo $@
	for n in vulnerable fixed latest; do \
		docker tag lighttpd:$$n $@:5000/$(ACCOUNT)/lighttpd:$$n; \
		docker push $@:5000/$(ACCOUNT)/lighttpd:$$n; \
	done
