using Gtk;

public class DensityGraphic : DrawingArea {
	public signal void list_updated ();
	public signal void list_reseted ();

	private const int AREA_WIDTH = 770;
	private const int AREA_HEIGHT = 320;

	private List<double?> _density_list_alive;
	public List<double?> density_list_alive {
		get { return _density_list_alive; }
		set {
			value.foreach((entry) => {
				_density_list_alive.append(entry);
			});
		}
	}
	
	private List<double?> _density_list_inf; 
	public List<double?> density_list_inf {
		get { return _density_list_inf; }
		set {
			value.foreach((entry) => {
				_density_list_inf.append(entry);
			});
		}
	}
	
	private List<double?> _density_list_dead;
	public List<double?> density_list_dead {
		get { return _density_list_dead; }
		set {
			value.foreach((entry) => {
				_density_list_dead.append(entry);
			});
		}
	}

	public DensityGraphic () {
		Object();
		set_size_request(AREA_WIDTH, AREA_HEIGHT);
		draw.connect(paint_graphic);
		create_components();
	}

	private void create_components () {
		_density_list_alive = new List<double?>();
		_density_list_inf = new List<double?>();
		_density_list_dead = new List<double?>();
	}
	
	public void add_density (double alive, double inf, double dead) {
		_density_list_alive.append(alive);
		_density_list_inf.append(inf);
		_density_list_dead.append(dead);
		
		this.hide();
		this.show();
		
		list_updated();
	}
	
	public void refresh_canvas () {
		this.hide();
		this.show();
	}
	
	public void reset () {
		_density_list_alive.foreach((entry) => {
			_density_list_alive.remove(entry);
		});
		
		_density_list_inf.foreach((entry) => {
			_density_list_inf.remove(entry);
		});
		
		_density_list_dead.foreach((entry) => {
			_density_list_dead.remove(entry);
		});
		
		this.hide();
		this.show();
		
		list_reseted();
	}

	private bool paint_graphic (Cairo.Context context) {
		context.set_source_rgba(0, 0, 0, 0.3);
		context.set_line_width(0.5);
		for (int x = 0; x <= 2000; x+= 10) {
			context.move_to((x * 3) + 10, 10);
			context.line_to((x * 3) + 10, AREA_HEIGHT - 10);
		}
		
		for (int x = 0; x <= 100; x+= 10) {
			context.move_to(10, (x * 3) + 10);
			context.line_to(AREA_WIDTH - 10, (x * 3) + 10);
		}
		
		context.stroke();
		context.set_source_rgba(0, 0, 0, 1);
		context.set_line_width(1);

		context.move_to(10, 10);
		context.line_to(10, AREA_HEIGHT - 10);
		context.line_to(AREA_WIDTH - 10, AREA_HEIGHT - 10);
		
		context.stroke();
		int i = 0;
		
		context.set_source_rgba(0, 0, 1, 1);
		context.set_line_width(2);
		
		_density_list_alive.foreach((entry) => {
			int y = (AREA_HEIGHT - 5) - (((int) entry * 3) + 10);
			int x = (i * 3) + 10;
			
			if (i == 0)
				context.move_to(x, y);
			else
				context.line_to(x, y);
			i++;
		});
		
		context.stroke();
		i = 0;
		
		context.set_source_rgba(0, 1, 0, 1);
		context.set_line_width(2);
		
		_density_list_inf.foreach((entry) => {
			int y = (AREA_HEIGHT - 5) - (((int) entry * 3) + 10);
			int x = (i * 3) + 10;
			
			if (i == 0)
				context.move_to(x, y);
			else
				context.line_to(x, y);
			i++;
		});
		
		context.stroke();
		i = 0;
		
		context.set_source_rgba(1, 0, 0, 1);
		context.set_line_width(2);
		
		_density_list_dead.foreach((entry) => {
			int y = (AREA_HEIGHT - 5) - (((int) entry * 3) + 10);
			int x = (i * 3) + 10;
			
			if (i == 0)
				context.move_to(x, y);
			else
				context.line_to(x, y);
			i++;
		});
		
		context.stroke();
		return true;
	}
}

