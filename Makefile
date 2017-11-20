.PHONY: build slate

build:
	docker run -ti -v $(PWD)/source:/slate/source -v $(PWD)/build:/slate/build slate
	docker build -t instruqt.com/docs .

run-local:
	docker run -ti -p 9999:80 instruqt.com/docs

slate:
	docker build -t slate:latest slate/.
