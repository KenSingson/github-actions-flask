build:
	docker build -t kensingson/flaskapp-aws:1.0.0 .

delete:
	docker rmi kensingson/flaskapp-aws:1.0.0

.PHONY: build