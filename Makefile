LIST = backup.yaml blood.yaml defence.yaml fareast.yaml
OUT = $(LIST:.yaml=.wiki)

all: $(OUT)

$(OUT): ge2rb.pl ability.yaml $(LIST)
	perl ge2rb.pl ability.yaml $(LIST)

ability.yaml: ge2rbcol.pl $(LIST)
	perl ge2rbcol.pl $(LIST) > $@

