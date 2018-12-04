all:
	docker build -t edoburu/python-runner:base ./base/
	docker build -t edoburu/python-runner:ansible ./ansible/
	docker build -t edoburu/python-runner:sphinx ./sphinx/
	docker build -t edoburu/python-runner:wkhtmltopdf ./wkhtmltopdf/

clean:
	docker rmi edoburu/python-runner:base edoburu/python-runner:ansible edoburu/python-runner:sphinx edoburu/python-runner:wkhtml2pdf
