.PHONY: all diagrams matplotlib gnuplot verify clean
all: diagrams matplotlib

diagrams:
	@mkdir -p generated
	dot -Tsvg architecture.dot -o generated/architecture.svg
	dot -Tpng architecture.dot -o generated/architecture.png
	dot -Tsvg lifecycle.dot -o generated/lifecycle.svg

matplotlib:
	@mkdir -p generated
	MPLCONFIGDIR=generated/.mpl-cache python3 benchmark.py

gnuplot:
	@mkdir -p generated
	gnuplot performance.gnuplot

verify:
	python3 verify_artifacts.py

clean:
	rm -rf generated
