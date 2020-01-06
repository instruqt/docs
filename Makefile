.PHONY: build slate

build:
	docker run -ti -v $(PWD)/source:/slate/source -v $(PWD)/docs:/slate/build gcr.io/instruqt/slate

slate:
	docker build -t gcr.io/instruqt/slate slate/.
