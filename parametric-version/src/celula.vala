public enum CellState { 
	DEAD, INF_A, INF_B, ALIVE 
}

public class Cell {
	private int _time;
	public int time {
		get { return _time; }
		set { _time = value; }
	}

	private CellState _state;
	public CellState state {
		get { return _state; }
		set { _state = value; }
	}

	public Cell (double chance) {
		int rounded_chance = (int) (chance * 10);
		_state = CellState.ALIVE;

		int rand = Random.int_range(0, 1000);
		for (int i = 0; i < rounded_chance; i++) {
			if (rand == i) {
				_state = CellState.INF_A;
				break;
			}
		}
		
		_time = 0;
	}

	public Cell.from_Cell (Cell cell) {
		this._state = cell.state;
		this._time = cell.time;
	}
}
