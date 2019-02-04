CC=Rscript
REND=compile.R
COMP=model.R

compile:
	$(CC) $(COMP)

render:
	$(CC) $(REND)

update: update.sh
	./update.sh

default: compile

all: render update
