# Makefile for deploying to multiple chains and environments

soldeer-publish:
	@cp package.json ./src/package.json && \
	cp README.md ./src/README.md && \
	VERSION=$$(node -p "require('./src/package.json').version"); \
	PACKAGE=$$(node -p "require('./src/package.json').name.replace(/[\.\-\/]/g, '-')"); \
	if soldeer push $$PACKAGE~$$VERSION src/; then \
		echo "Successfully published $$PACKAGE version $$VERSION"; \
	else \
		echo "Failed to publish $$PACKAGE version $$VERSION"; \
	fi; \
	rm ./src/package.json ./src/README.md;

# Default target
.DEFAULT_GOAL := soldeer-publish
