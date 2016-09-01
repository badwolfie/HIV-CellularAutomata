using Gtk;

public class GraphicDialog : Dialog {
	private string message;

	private DensityGraphic _graphic;
	public DensityGraphic graphic {
		get { return _graphic; }
	}
	
	public GraphicDialog (VentanaSimulador window, int iteraciones, int r_a, int r_b, int lag) {
		set_transient_for(window);
		set_size_request(600, 300);
		border_width = 0;
		
		message = "Mostrando %d iteraciones: ".printf(iteraciones) + 
			"R<span size='small' rise='-3000'>a</span> = %d, ".printf(r_a) + 
			"R<span size='small' rise='-3000'>b</span> = %d, ".printf(r_b) + 
			"τ = %d".printf(lag);
		
		create_widgets();
	}

	void create_widgets () {
		var headerbar = new HeaderBar();
		headerbar.title = "Gráfica de densidades";
		set_titlebar(headerbar);
		headerbar.show();
		
		var label = new Label(message);
		label.use_markup = true;
		label.show();
		
		var button = new Button.with_mnemonic("_Cerrar");
		button.clicked.connect(() => { this.destroy(); });
		button.width_request = 70;
		
		headerbar.pack_end(button);
		button.show();
		
		var context = button.get_style_context();
		context.add_class("destructive-action");
		
		_graphic = new DensityGraphic();
		_graphic.show();
		
		var content = get_content_area() as Box;
		content.pack_start(label,true,true,0);
		content.pack_start(_graphic,true,true,0);
		content.show();
	}
	
	public void set_lists (List<double?> alive, List<double?> inf, List<double?> dead) {
		_graphic.density_list_alive = alive;
		_graphic.density_list_inf = inf;
		_graphic.density_list_dead = dead;
	}
}

