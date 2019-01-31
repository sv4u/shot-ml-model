CC=Rscript
FILE=compile.R

render: compile.R
	$(CC) $(FILE)

update: update.sh
	./update.sh

default: render

all: render update
