all: pdf

# Really clean should clean here and in subdirectories
# Most notably it should at least clean .blg and .bbl files
clean:
	-rm -f *.aux *.log *.dvi *.blg *.bbl *.inx *.aut *.toc *.out desc_white_paper.pdf
	-rm -f */*.aux */*.log */*.dvi */*.blg */*.bbl */*.inx */*.aut */*.toc */*.out 
	-rm -f */*/*.aux */*/*.log */*/*.dvi */*/*.blg */*/*.bbl */*/*.inx */*/*.aut */*/*.toc */*/*.out 

# No longer needed if exgal_roadmap.pdf is removed anyway...
# trash: clean
# 	-rm -f exgal_roadmap.pdf
# 
# force: trash exgal_roadmap.pdf

pdf: exgal_roadmap.pdf

ps: exgal_roadmap.pdf
	pdf2ps exgal_roadmap.pdf

TEXFILES = *.tex */*.tex */*/*.tex
#BIBFILES = general.bib */*.bib
#BIBFILES = */*.bib
BIBFILES= */*/*.bib
check:
	./checkbook.csh

# Problem: how to get current version number?

# Old code, based on svn status call:
# # This pulls out the version number and stamps it on the front cover.
# # You have to type your password (twice) so only do it when making final!
# versiondate:
# 	(echo '\begin{center}') > VersionDate.tex
# 	(svn status --show-updates --verbose wc | sed 's/Status against revision: /Version /') >> VersionDate.tex
# 	(echo ' ') >> VersionDate.tex
# 	(date +"%B %d, %Y") >> VersionDate.tex
# 	(echo '\end{center}') >> VersionDate.tex
# 
# # Have to have something in VersionDate.tex! Here's a dummy version, date but
# # no version number:	
# dummyversiondate:
# 	(echo '\begin{center}') > VersionDate.tex
# 	(echo 'Draft Version') >> VersionDate.tex
# 	(echo ' ') >> VersionDate.tex
# 	(date +"%B %d, %Y") >> VersionDate.tex
# 	(echo '\end{center}') >> VersionDate.tex

# New code (PJM 2009-01-29), based on contents of entries file.
# Differences between mac and linux in how echo deals with escape chars,
#   switched to clunkier cat commands (PJM 2009-02-09)
# 2009/05/24 - MWV: The '-n' from the echo was ending up in the 'VersionDate.tex' file
#                   Under Bash 'echo' is /bin/echo.  Under Tcsh 'echo' is a shell command.
#                   Changing things to always use /bin/echo worked.  
#                   This seems a safe-enough assumption but I don't like having to make it.
versiondate:
	(cat VersionDate.begin) > VersionDate.tex
	(/bin/echo -n "Version "; tail -n +4 .svn/entries | head -1 | sed -e 's/-n//') >> VersionDate.tex
	(echo ' ') >> VersionDate.tex
	(date +"%B %d, %Y") >> VersionDate.tex
	(cat VersionDate.end) >> VersionDate.tex
 
# Note: VersionDate.tex MUST exist for exgal_roadmap to compile! 
exgal_roadmap.pdf: clean versiondate exgal_roadmap.tex whitepaper.sty $(BIBFILES) $(TEXFILES)
	pdflatex exgal_roadmap.tex
	pdflatex exgal_roadmap.tex
	# PJM: this almost works, but not quite...
	bibtex exgal_roadmap
	pdflatex exgal_roadmap.tex
	pdflatex exgal_roadmap.tex

# Generate finalised version of the book, with no line numbers:
final: setfinal exgal_roadmap.pdf

# Generate draft version of the book, with line numbers, 
# and restore default (final) settings afterwards:
draft: setdraft exgal_roadmap.pdf setfinal

# Fiddling needed by previous options:
setfinal:
	cat whitepaper.sty | sed s/'setboolean{draft}{true}'/'setboolean{draft}{false}'/g > junk
	mv junk whitepaper.sty
	echo "*** whitepaper.sty edited for final version ***" >& /dev/null

setdraft:
	cat whitepaper.sty | sed s/'setboolean{draft}{false}'/'setboolean{draft}{true}'/g > junk
	mv junk whitepaper.sty
	echo "*** whitepaper.sty edited for draft version ***" >& /dev/null

