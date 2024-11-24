.PHONY: deploy

deploy:
	@VERSION=$$(node -p "require('./package.json').version"); \
	MAJOR=$$(echo $$VERSION | cut -d. -f1); \
	MINOR=$$(echo $$VERSION | cut -d. -f2); \
	PATCH=$$(echo $$VERSION | cut -d. -f3); \
	NEW_PATCH=$$((PATCH + 1)); \
	NEW_VERSION="$$MAJOR.$$MINOR.$$NEW_PATCH"; \
	echo "Updating version from $$VERSION to $$NEW_VERSION"; \
	sed -i.bak "s/\"version\": \"$$VERSION\"/\"version\": \"$$NEW_VERSION\"/" package.json; \
	sed -i.bak "s/@kei-fi-testing-lib~$$VERSION/@kei-fi-testing-lib~$$NEW_VERSION/" package.json; \
	rm package.json.bak; \
	soldeer push @kei-fi-testing-lib~$$NEW_VERSION