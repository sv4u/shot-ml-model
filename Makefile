CC=Rscript
FILE=model.R

render:
	$(CC) $(FILE)

update: update.sh
	./update.sh

default: render

all: render update
