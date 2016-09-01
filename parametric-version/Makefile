OUTPUT = simulador-vih
OPTIONS = --pkg gtk+-3.0 --thread --target-glib=2.32
SOURCES = \
	src/celula.vala \
	src/dialogo-grafica.vala \
	src/evaluador.vala \
	src/grafico-densidad.vala \
	src/lattice.vala \
	src/simulador-vih.vala \
	src/ventana-simulador.vala 

all: $(OUTPUT) run

$(OUTPUT): $(SOURCES)
	valac -o $(OUTPUT) $(OPTIONS) $(SOURCES)

ccode: $(SOURCES)
	valac -C $(OPTIONS) $(SOURCES)

clean:
	$(RM) $(OUTPUT)

run:
	./$(OUTPUT)
