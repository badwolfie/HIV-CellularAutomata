public class Evaluador {
	private Lattice lattice;
	
	int x_inicial;
	int x_final;
	int y_inicial;
	int y_final;
	
	public Evaluador (ref Lattice lattice, int sector) {
		this.lattice = lattice;
		
		switch (sector) {
			case 1:
				x_inicial = 0;
				x_final = lattice.lattice_size / 2;
				
				y_inicial = 0;
				y_final = lattice.lattice_size / 2;
				break;
			case 2:
				x_inicial = lattice.lattice_size / 2;
				x_final = lattice.lattice_size;
				
				y_inicial = 0;
				y_final = lattice.lattice_size / 2;
				break;
			case 3:
				x_inicial = 0;
				x_final = lattice.lattice_size / 2;
				
				y_inicial = lattice.lattice_size / 2;
				y_final = lattice.lattice_size;
				break;
			case 4:
				x_inicial = lattice.lattice_size / 2;
				x_final = lattice.lattice_size;
				
				y_inicial = lattice.lattice_size / 2;
				y_final = lattice.lattice_size;
				break;
		}
	}
	
	public void * run () {
		for (int i = x_inicial; i < x_final; i++) {
			for (int j = y_inicial; j < y_final; j++) {
				int inf_a = count_infected(i, j, CellState.INF_A);
				int inf_b = count_infected(i, j, CellState.INF_B);

				lattice.cells_new[i,j].state = 
					eval(ref lattice.cells[i,j], inf_a, inf_b);
			}
		}
		
		return null;
	}
	
	public void * refresh () {
		for (int i = x_inicial; i < x_final; i++) {
			for (int j = y_inicial; j < y_final; j++) {
				lattice.cells[i,j].state = lattice.cells_new[i,j].state;
			}
		}
		
		return null;
	}
	
	private int count_infected (int x, int y, CellState value) {
		int x_prev = (x + (lattice.lattice_size - 1)) % lattice.lattice_size;
		int x_next = (x + 1) % lattice.lattice_size;

		int y_prev = (y + (lattice.lattice_size - 1)) % lattice.lattice_size;
		int y_next = (y + 1) % lattice.lattice_size;

		int infected = 0;

		if (lattice.cells[x_prev,y_prev].state == value) infected++;
		if (lattice.cells[x_prev,y].state == value) infected++;
		if (lattice.cells[x_prev,y_next].state == value) infected++;
		if (lattice.cells[x,y_prev].state == value) infected++;
		if (lattice.cells[x,y_next].state == value) infected++;
		if (lattice.cells[x_next,y_prev].state == value) infected++;
		if (lattice.cells[x_next,y].state == value) infected++;
		if (lattice.cells[x_next,y_next].state == value) infected++;

		return infected;
	}
	
	private CellState eval (ref Cell current, int inf_a, int inf_b) {
		CellState value = current.state;

		switch (current.state) {
			case CellState.ALIVE:
				if ((inf_a >= lattice.r_a) || (inf_b >= lattice.r_b))
					value = CellState.INF_A;
				break;
			case CellState.INF_A:
				current.time = (current.time + 1) % lattice.lag;
				if (current.time == 0)
					value = CellState.INF_B;
				break;
			case CellState.INF_B:
				value = CellState.DEAD;
				break;
			case CellState.DEAD:
				int rand_repl = Random.int_range(0, 100);
				if (rand_repl != 0) {
					value = CellState.ALIVE;
					int rand_inf = Random.int_range(0, 10000);
					
					if (rand_inf == 1) 
						value = CellState.INF_A;
				}
				
				break;
		}
		
		return value;
	}
}

