.PHONY: build slate

build:
	docker run -ti -v $(PWD)/source:/slate/source -v $(PWD)/docs:/slate/build gcr.io/instruqt/slate
	docker run -v $(PWD)/docs:/docs -u $$(id -u):$$(id -g) sticksnleaves/graphdoc graphdoc -e https://play.instruqt.com/graphql -o ./docs/api --force
	cp CNAME docs

slate:
	docker build -t gcr.io/instruqt/slate slate/.