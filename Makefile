index.html:
	@bundle exec slimrb index.slim > $@

watch:
	@bundle exec guard start

.PHONY: index.html watch
