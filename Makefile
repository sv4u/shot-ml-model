CC=Rscript
REND=model.Rmd
COMP=model.R

compile:
	$(CC) $(COMP)

render:
	$(CC) $(REND)

update: update.sh
	./update.sh

default: compile

all: render update
