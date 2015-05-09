LIST = backup1.yaml backup2.yaml blood.yaml bloodA.yaml defence.yaml defenceA.yaml fareast1.yaml fareast1A.yaml fareast2.yaml fareast2A.yaml
OUT = $(LIST:.yaml=.wiki)
BASE = $(LIST:.yaml=)

all: $(OUT)

$(OUT): ge2rb.pl ability.yaml $(LIST)
	perl ge2rb.pl ability.yaml $(LIST)

ability.yaml: ge2rbcol.pl $(LIST)
	perl ge2rbcol.pl $(LIST) > $@

reverse:
	/bin/sh -c 'for i in $(BASE); do mv $${i}.yaml $${i}.bak.yaml; perl ge2rbrev.pl $${i}.wiki > $${i}.yaml; done'

get:
	perl ge2rbget.pl url.yaml

clean:
	rm *#.yaml *.wiki
