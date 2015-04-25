LIST = backup.yaml blood.yaml defence.yaml fareast.yaml fareast2.yaml
OUT = $(LIST:.yaml=.wiki)

all: $(OUT)

$(OUT): ge2rb.pl ability.yaml $(LIST)
	perl ge2rb.pl ability.yaml $(LIST)

ability.yaml: ge2rbcol.pl $(LIST)
	perl ge2rbcol.pl $(LIST) > $@

reverse:
	mv backup.yaml backup.yaml.bak
	perl ge2rbrev.pl backup.wiki > backup.yaml
	mv blood.yaml blood.yaml.bak
	perl ge2rbrev.pl blood.wiki > blood.yaml
	mv fareast.yaml fareast.yaml.bak
	perl ge2rbrev.pl fareast.wiki > fareast.yaml
	mv backup.yaml backup.yaml.bak
	perl ge2rbrev.pl backup.wiki > backup.yaml

get:
	perl ge2rbget.pl url.yaml
