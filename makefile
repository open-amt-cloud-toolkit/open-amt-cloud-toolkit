.PHONY: build run

build:
	read -p "Enter IP Address:" ip; \
	sed -i -e "s|\"common_name\": \".*|\"common_name\": \"$$ip\"\,|g" ./mps/.mpsrc -e "s|'localhost'|\'$$ip\'|g" ./sample-web-ui/src/app.config.js -e "s|\"cors_origin\": \".*|\"cors_origin\": \"http://$$ip:3001\"\,|g" ./mps/.mpsrc 
	cd ./mps && npm install
	cd ./rps && npm install
	cd ./sample-web-ui && npm install

MICROSERVICES= \
	run-ui & \
	run-mps & \
	run-rps  \

.PHONY: $(MICROSERVICES)

run-rps: 
	(cd ./rps && npm run devx)

run-ui: 
	(cd ./sample-web-ui && npm start)

run-mps: 
	(cd ./mps && npm run devx) 

run:
	echo "run each service in a separate terminal window (i.e. make run-ui)"

