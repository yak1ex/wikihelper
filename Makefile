LIST = backup.yaml blood.yaml defence.yaml fareast.yaml fareast2.yaml
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
