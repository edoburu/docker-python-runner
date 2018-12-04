all:
	docker build -t edoburu/python-runner:base ./base/
	docker build -t edoburu/python-runner:ansible ./ansible/
	docker build -t edoburu/python-runner:sphinx ./sphinx/
	docker build -t edoburu/python-runner:wkhtmltopdf ./wkhtmltopdf/
	docker tag edoburu/python-runner:base edoburu/python-runner:latest

push:
	docker login
	docker push edoburu/python-runner:base
	docker push edoburu/python-runner:latest
	docker push edoburu/python-runner:sphinx
	docker push edoburu/python-runner:ansible
	docker push edoburu/python-runner:wkhtmltopdf

clean:
	docker rmi edoburu/python-runner:base edoburu/python-runner:ansible edoburu/python-runner:sphinx edoburu/python-runner:wkhtml2pdf edoburu/python-runner:latest
