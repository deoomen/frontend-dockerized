include .env

ARGS = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`

define detect_ports
	FRAMEWORK_INFO=$$(./docker/detect-framework.sh ${PROJECT_NAME} 2>/dev/null || echo "DETECTED_FRAMEWORK=unknown\nDETECTED_PORT=5173"); \
	DETECTED_FRAMEWORK=$$(echo "$$FRAMEWORK_INFO" | grep DETECTED_FRAMEWORK | cut -d'=' -f2); \
	DETECTED_PORT=$$(echo "$$FRAMEWORK_INFO" | grep DETECTED_PORT | cut -d'=' -f2); \
	echo "\033[0;33mDetected framework:\033[0m $$DETECTED_FRAMEWORK (port: $$DETECTED_PORT)"
endef

%:
	@:

help:	## Show this help
	@echo "Welcome to \033[0;32mReact Dockerized template project\033[0m."
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m ENV=<value>\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@echo "\n\033[0;33mNote:\033[0m Ports will be automatically detected based on the framework:"
	@echo "  - Next.js: 3000"
	@echo "  - Expo: 8081"
	@echo "  - React/Vue/Vite: 5173"
	@echo "\n\033[0;36mFramework Initialization:\033[0m"
	@echo "  make init-next   - Next.js with App Router"
	@echo "  make init-react  - React with React Router v7"
	@echo "  make init-expo   - Expo for React Native"
	@echo "  make init-vue    - Vue.js application"


build:	## Build dockers from docker compose
	@START=$$(date +%s); \
	if [ ! -d "${PROJECT_NAME}" ]; then mkdir ${PROJECT_NAME}; fi; \
	docker compose \
	build \
	--build-arg PROJECT_NAME=${PROJECT_NAME} \
	--build-arg PORT_HOST=${PORT_CONTAINER} \
	--build-arg NODE_ENV=${NODE_ENV} \
	--pull \
	--no-cache; \
	STOP=$$(date +%s); \
	echo "\033[0;32mBuild took $$((STOP-START)) seconds\033[0m"

build-smart:	## Build with framework detection (used after project init)
	@$(call detect_ports); \
	START=$$(date +%s); \
	PORT_HOST=$$DETECTED_PORT PORT_CONTAINER=$$DETECTED_PORT \
	docker compose \
	build \
	--build-arg PROJECT_NAME=${PROJECT_NAME} \
	--build-arg PORT_HOST=$$DETECTED_PORT \
	--build-arg NODE_ENV=${NODE_ENV}; \
	STOP=$$(date +%s); \
	echo "\033[0;32mBuild took $$((STOP-START)) seconds\033[0m"; \

init-next:	## Initialize a new React App with Next.js (App Router)
	@make build
	@docker run -it -d -v ./:/app --name ${IMAGE_NAME} ${IMAGE_NAME} sh
	@docker exec -it ${IMAGE_NAME} sh -c "npx create-next-app@latest ${PROJECT_NAME}"
	@docker rm -f ${IMAGE_NAME}
	@make build-smart

init-react:	## Initialize a new React App with React Router (v7)
	@make build
	@docker run -it -d -v ./:/app --name ${IMAGE_NAME} ${IMAGE_NAME} sh
	@docker exec -it ${IMAGE_NAME} sh -c "npx create-react-router@latest ${PROJECT_NAME} --no-git-init --no-install"
	@docker rm -f ${IMAGE_NAME}
	@make build-smart

init-expo:	## Initialize a new React App with Expo (for native apps)
	@make build
	@docker run -it -d -v ./:/app --name ${IMAGE_NAME} ${IMAGE_NAME} sh
	@docker exec -it ${IMAGE_NAME} sh -c "npx create-expo-app@latest ${PROJECT_NAME}"
	@docker rm -f ${IMAGE_NAME}
	@make build-smart

init-vue:	## Initialize a new Vue App
	@make build
	@docker run -it -d -v ./:/app --name ${IMAGE_NAME} ${IMAGE_NAME} sh
	@docker exec -it ${IMAGE_NAME} sh -c "npm create vue@latest ${PROJECT_NAME}"
	@docker rm -f ${IMAGE_NAME}
	@make build-smart

up:	## Start dockers from docker composer
	@$(call detect_ports); \
	echo "\033[0;33mUsing ports:\033[0m Host: $$DETECTED_PORT -> Container: $$DETECTED_PORT"; \
	PORT_HOST=$$DETECTED_PORT PORT_CONTAINER=$$DETECTED_PORT docker compose up -d --remove-orphans --wait; \
	echo "\033[0;32mSoon your project will be available at \033[1;32mhttp://localhost:$$DETECTED_PORT\033[0m";

down:	## Stop dockers from docker composer
	@docker compose down

start:	## Start dockers from docker composer
	@docker compose start

stop:	## Stop dockers from docker composer
	@docker compose stop

clean:	## Clean up all stopped containers and unused images
	@make down
	@docker rmi ${IMAGE_NAME}

npm:	## Run npm command in the project
	@docker exec -it ${IMAGE_NAME} sh -c "npm $(ARGS)"

shell:	## Go to shell in the project
	@docker exec -it ${IMAGE_NAME} sh
