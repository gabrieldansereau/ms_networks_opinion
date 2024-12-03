.PHONY: all

all: 

typepath=../manuscript-typesetter

# Manuscript template
set-typesetter:
	rm .typesetter
	ln -sf $(typepath) .typesetter
	(cd .typesetter; git checkout ms_networks_opinion)

run-full:
	julia --project=.typesetter .typesetter/scripts/00_build.jl
	# Say [no] to replacing LICENSE

run-downloads:
	julia --project=.typesetter .typesetter/scripts/01_downloads.jl

run-build:
	julia --project=.typesetter .typesetter/scripts/02_metadata.jl
	julia --project=.typesetter .typesetter/scripts/03_folders.jl
	julia --project=.typesetter .typesetter/scripts/04_run.jl

draft:
	./pandoc-2.19.2/bin/pandoc README.md -s -o dist/draft.pdf -F pandoc-crossref --citeproc --bibliography=references.json --csl .typesetter/citationstyle.csl --metadata-file=manuscript-metadata.json --pdf-engine ./tectonic --template=.typesetter/templates/draft.tex

preprint:
	./pandoc-2.19.2/bin/pandoc README.md -s -o dist/preprint.pdf --pdf-engine ./tectonic -F pandoc-crossref --citeproc --bibliography=references.json --csl .typesetter/citationstyle.csl --metadata-file=manuscript-metadata.json --template=.typesetter/templates/preprint.tex

clean:
	rm .fonts pandoc-* manuscript-metadata.json references.json tectonic* -vrf

clean-all: clean
	rm -vrf dist
