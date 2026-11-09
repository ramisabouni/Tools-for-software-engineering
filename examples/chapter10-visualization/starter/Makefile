.PHONY: all validate diagrams plots verify clean
all: validate diagrams plots

validate:
	@mkdir -p generated
	python3 validate.py

diagrams:
	@mkdir -p generated
	dot -Tsvg architecture.dot -o generated/architecture.svg
	dot -Tsvg state-machine.dot -o generated/state-machine.svg

plots: validate
	MPLCONFIGDIR=generated/.mpl-cache python3 plot-template.py

verify:
	@echo 'TODO: verify counts, labels, files, and manifest digests'

clean:
	rm -rf generated
