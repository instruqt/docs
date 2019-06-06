.PHONY: build slate

build:
	docker run -ti -v $(PWD)/source:/slate/source -v $(PWD)/build:/slate/build gcr.io/instruqt/slate
	docker build -t instruqt/docs .

run-local:
	docker run -ti -p 9999:80 instruqt/docs

slate:
	docker build -t gcr.io/instruqt/slate slate/.
