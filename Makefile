TARGET=main.pdf
LL=pdflatex

all: revision.tex authors.tex $(TARGET)

pdf: revision.tex authors.tex $(TARGET)

.PHONY : clean revision.tex authors.tex $(TARGET)

revision.tex:
	echo "% Autogenerated, do not edit" > revision.tex
	echo "\\\\newcommand{\\\\revisiondate}{`date -d @$$(git log -n1 --format="%at") +%d.%m.%Y`}" >> revision.tex
	echo "\\\\newcommand{\\\\revision}{`git log -1 --format=\"%h\"`}" >> revision.tex
	echo "\\\\newcommand{\\\\gitTag}{`git name-rev --tags --name-only $$(git rev-parse HEAD)`}" >> revision.tex


authors.tex:
	echo '% Autogenerated, do not edit' > authors.tex
	echo \\\\newcommand{\\\\gitAuthors}{`git log --format='%aN \\\\\\\\ %aE' | cut -c1- | sort -u | awk -v RS='' '{gsub (/\n/,"\n \\\\\\\\and \n")}1'`} >> authors.tex

$(TARGET): $(TARGET:%.pdf=%.tex) $(SRC)
		$(LL) $<

clean:
	rm -rf main.aux main.log main.toc
	rm -f revision.tex authors.tex main.pdf
