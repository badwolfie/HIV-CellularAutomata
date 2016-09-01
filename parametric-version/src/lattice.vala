using Gtk;

public class Lattice : DrawingArea {
	private int total_size;
	private int _lattice_size;
	public int lattice_size {
		get { return _lattice_size; }
	}
	
	private double chance;
	
	private int _r_a;
	public int r_a {
		get { return _r_a; }
		set { _r_a = value; }
	}
	
	private int _r_b;
	public int r_b {
		get { return _r_b; }
		set { _r_b = value; }
	}
	
	private int _lag;
	public int lag {
		get { return _lag; }
		set { _lag = value; }
	}
	
	private double _density_alive;
	public double density_alive {
		get { return _density_alive; }
		set { _density_alive = value; }
	}
	
	private double _density_inf;
	public double density_inf {
		get { return _density_inf; }
		set { _density_inf = value; }
	}
	
	private double _density_dead;
	public double density_dead {
		get { return _density_dead; }
		set { _density_dead = value; }
	}

	private Cell[,] _cells;
	public Cell[,] cells {
		get { return _cells; }
	}

	private Cell[,] _cells_new;
	public Cell[,] cells_new {
		get { return _cells_new; }
	}

	public Lattice (int lattice_size, double chance) {
		Object();
		set_size_request(lattice_size, lattice_size);
		draw.connect(paint_grid);

		this._lattice_size = lattice_size;
		total_size = lattice_size * lattice_size;
		this.chance = chance;
		create_components();
	}

	private void create_components () {
		_cells_new = new Cell[_lattice_size,_lattice_size];
		_cells = new Cell[_lattice_size,_lattice_size];

		for (int i = 0; i < _lattice_size; i++) {
			for (int j = 0; j < _lattice_size; j++) {
				_cells[i,j] = new Cell(chance);
				_cells_new[i,j] = new Cell.from_Cell(_cells[i,j]);
			}
		}
	}

	private bool paint_grid (Cairo.Context context) {
		int alive = 0, inf = 0, dead = 0;
	
		for (int i = 0; i < _lattice_size; i++) {
			for (int j = 0; j < _lattice_size; j++) {
				switch (_cells[i,j].state) {
					case CellState.ALIVE:
						context.set_source_rgba(0.35, 0.76, 0.94, 1);
						alive++;
						break;
					case CellState.INF_A:
						context.set_source_rgba(0.96, 0.94, 0.29, 1);
						inf++;
						break;
					case CellState.INF_B:
						context.set_source_rgba(0.31, 0.66, 0.15, 1);
						inf++;
						break;
					case CellState.DEAD:
						context.set_source_rgba(0.82, 0.15, 0.13, 1);
						dead++;
						break;
				}

				context.rectangle(j, i, 1, 1);
				context.fill();
			}
		}
		
		_density_alive = ((double) alive / (double) total_size) * 100;
		_density_inf = ((double) inf / (double) total_size) * 100;
		_density_dead = ((double) dead / (double) total_size) * 100;
		
		return true;
	}
}

