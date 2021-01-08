
include hub/*.mk

prep: $(preps)

start: $(starts)

stop: $(stops)

clean: $(cleans)


# gruesomely needed to stop deletion of supposedly-intermediate files
.SECONDARY:

