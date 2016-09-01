using Gtk;

private enum OperationType {
	IDLE, CLEANED, GENERATED, RUNNING, PAUSED, STOPPED 
}

public class VentanaSimulador : ApplicationWindow {
	private HeaderBar right_headerbar;
	private HeaderBar left_headerbar;

	private ScrolledWindow scroll;
	private ListBox controles;
	private CheckButton mostrar_espacio;

	private Button play_pause_button;
	private Image play_img;
	private Image pause_img;

	private SpinButton size_button;
	private SpinButton infec_button;
	private Button generate_button;
	private Button clean_button;

	private Label statusbar;
	private SpinButton lag_button;
	private SpinButton r_a_button;
	private SpinButton r_b_button;

	public GraphicDialog dialog;
	private Box content;
	
	private Evaluador[] eval;
	private Lattice lattice;
	
	private List<double?> density_list_alive;
	private List<double?> density_list_inf;
	private List<double?> density_list_dead;

	private int running_time;
	private bool running;
	private bool init;

	public VentanaSimulador (Gtk.Application app) {
		Object(application: app);

		window_position = WindowPosition.CENTER_ALWAYS;
		set_default_size(750, 500);
		set_resizable(false);
		border_width = 0;

		running_time = 0;
		running = false;
		init = false;

		create_widgets();
	}

	private void create_widgets () {
		scroll = new ScrolledWindow(null, null);
		scroll.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);
		scroll.width_request = 500;
		scroll.height_request = 500;
		scroll.show();
	
		left_headerbar = new HeaderBar();
		left_headerbar.show();

		left_headerbar.set_show_close_button(false);
		left_headerbar.set_title("Controles");
		left_headerbar.decoration_layout = ":minimize,close";
		left_headerbar.width_request = 250;

		right_headerbar = new HeaderBar();
		right_headerbar.show();

		right_headerbar.set_show_close_button(true);
		right_headerbar.set_title("Simulador VIH");
		right_headerbar.decoration_layout = ":minimize,close";

		var separator_header = new Separator(Orientation.VERTICAL);
		separator_header.show();

		var headerbar = new Box(Orientation.HORIZONTAL, 0);

		headerbar.pack_start(left_headerbar, false, true, 0);
		headerbar.pack_start(separator_header, false, true, 0);
		headerbar.pack_start(right_headerbar, true, true, 0);

		set_titlebar(headerbar);
		headerbar.show();

		controles = new ListBox();
		controles.selection_mode = SelectionMode.NONE;
		controles.height_request = 500;
		controles.width_request = 250;
		controles.show();
	
		var size_label = new Label("<b>Tamaño del espacio:</b>");
		size_label.use_markup = true;
		size_label.show();
		
		size_button = new SpinButton.with_range(200, 1000, 100);
		size_button.set_value((double) 500);
		size_button.show();
		
		var empty1 = new Label("<span size='xx-small'> </span>");
		empty1.use_markup = true;
		empty1.wrap_mode = Pango.WrapMode.WORD;
		empty1.max_width_chars = -1;
		empty1.show();
		
		size_button.value_changed.connect(() => {
			int value = size_button.get_value_as_int();
			if (value >= 700) {
				empty1.label = "<span size='small' color='red'>" + 
					"¡Advertencia! A mayor número \n" + 
					"de elementos, el rendimiento \n" + 
					"de la aplicación se verá más \n" + 
					"afectado." +  
					"</span>";
			} else {
				empty1.label = "<span size='xx-small'> </span>";
			}
		});
		
		var infec_label = new Label("<b>Infección inicial (%):</b>");
		infec_label.use_markup = true;
		infec_label.show();
		
		infec_button = new SpinButton.with_range(1, 8, 0.5);
		infec_button.set_value((double) 5);
		infec_button.show();
		
		mostrar_espacio = new CheckButton.with_label("Mostrar espacio");
		mostrar_espacio.active = true;
		mostrar_espacio.show();
		
		mostrar_espacio.toggled.connect(() => {
			if (mostrar_espacio.active) {
				left_headerbar.set_show_close_button(false);
				right_headerbar.show_all();
				scroll.show_all();
			} else {
				left_headerbar.set_show_close_button(true);
				right_headerbar.hide();
				scroll.hide();
			}
		});
		
		var r_a_label = new Label(
			"<b>R<span size='small' rise='-3000'>a</span></b>");
		r_a_label.halign = Align.START;
		r_a_label.use_markup = true;
		r_a_label.show();

		r_a_button = new SpinButton.with_range(1, 8, 1);
		r_a_button.set_value((double) 1);
		r_a_button.show();

		var hbox1 = new Box(Orientation.HORIZONTAL, 0);
		hbox1.pack_start(r_a_label, false, true, 15);
		hbox1.pack_start(r_a_button, true, false, 0);
		hbox1.homogeneous = false;
		hbox1.show();

		var r_b_label = new Label(
			"<b>R<span size='small' rise='-3000'>b</span></b>");
		r_b_label.halign = Align.START;
		r_b_label.use_markup = true;
		r_b_label.show();

		r_b_button = new SpinButton.with_range(1, 8, 1);
		r_b_button.set_value((double) 4);
		r_b_button.show();

		var hbox2 = new Box(Orientation.HORIZONTAL, 0);
		hbox2.pack_start(r_b_label, false, true, 15);
		hbox2.pack_start(r_b_button, true, false, 0);
		hbox2.homogeneous = false;
		hbox2.show();

		var lag_label = new Label("<b>τ</b>");
		lag_label.halign = Align.START;
		lag_label.use_markup = true;
		lag_label.show();

		lag_button = new SpinButton.with_range(1, 8, 1);
		lag_button.set_value((double) 4);
		lag_button.show();

		var hbox3 = new Box(Orientation.HORIZONTAL, 0);
		hbox3.pack_start(lag_label, false, true, 18);
		hbox3.pack_start(lag_button, true, false, 0);
		hbox3.homogeneous = false;
		hbox3.show();
		
		generate_button = new Button.with_mnemonic("_Generar");
		generate_button.clicked.connect(init_lattice);
		generate_button.set_tooltip_text("Generar tablero");
		generate_button.show();

		clean_button = new Button.with_mnemonic("_Limpiar");
		clean_button.set_tooltip_text("Limpiar tablero");
		clean_button.clicked.connect(on_clean_clicked);
		clean_button.sensitive = false;
		clean_button.show();

		var hbox4 = new Box(Orientation.HORIZONTAL, 0);
		hbox4.pack_start(clean_button, false, true, 10);
		hbox4.pack_start(generate_button, false, true, 10);
		hbox4.homogeneous = true;
		hbox4.show();

		pause_img = new Image.from_icon_name("media-playback-pause-symbolic",
			IconSize.MENU);
		pause_img.show();

		play_img = new Image.from_icon_name("media-playback-start-symbolic",
		   IconSize.MENU);
		play_img.show();

		play_pause_button = new Button();
		play_pause_button.clicked.connect(on_play_pause_clicked);
		play_pause_button.set_tooltip_text("Correr/Pausar");
		
		play_pause_button.sensitive = false;
		play_pause_button.add(play_img);
		play_pause_button.show();

		var accels = new AccelGroup();
		this.add_accel_group(accels);
		play_pause_button.add_accelerator("activate", accels, Gdk.Key.space,
			Gdk.ModifierType.META_MASK, AccelFlags.VISIBLE);
		var context_play_pause = play_pause_button.get_style_context();
		context_play_pause.add_class("image-button");

		var hide_button = new Button.from_icon_name("go-previous-symbolic", 
			IconSize.MENU);
		hide_button.set_tooltip_text("Esconder controles");
		hide_button.clicked.connect(() => {
			Image img;
			if (left_headerbar.get_visible()) {
				img = new Image.from_icon_name("go-next-symbolic",
					IconSize.MENU);
				hide_button.set_tooltip_text("Mostrar controles");
				left_headerbar.hide();
				controles.hide();
			} else {
				img = new Image.from_icon_name("go-previous-symbolic", 
					IconSize.MENU);
				hide_button.set_tooltip_text("Esconder controles");
				left_headerbar.show_all();
				controles.show_all();
			}
			
			hide_button.remove(hide_button.get_child());
			hide_button.add(img);
			img.show();
		});
		
		var context_hide = hide_button.get_style_context();
		context_hide.add_class("image-button");
		hide_button.show();

		// right_headerbar.pack_start(hide_button);
		left_headerbar.pack_end(play_pause_button);

		content = new Box(Orientation.HORIZONTAL, 0);
		var separator_content = new Separator(Orientation.VERTICAL);
		separator_content.show();

		content.pack_start(controles, false, true, 0);
		content.pack_start(separator_content, false, true, 0);
		content.pack_start(scroll,true,true,0);

		var empty2 = new Label("<span size='xx-small'> </span>");
		empty2.use_markup = true;
		empty2.show();

		var label_var = new Label("<b>Variables</b>");
		label_var.use_markup = true;
		label_var.show();

		var empty3 = new Label("<span size='xx-small'> </span>");
		empty3.use_markup = true;
		empty3.show();

		var label_edo = new Label("<b>Estado actual</b>");
		label_edo.use_markup = true;
		label_edo.show();

		statusbar = new Label("Esperando...");
		statusbar.wrap_mode = Pango.WrapMode.WORD;
		statusbar.max_width_chars = -1;
		statusbar.use_markup = true;
		statusbar.wrap = true;
		statusbar.show();
		
		size_label.halign = Align.CENTER;
		size_button.halign = Align.CENTER;
		mostrar_espacio.halign = Align.CENTER;
		empty1.halign = Align.CENTER;
		infec_label.halign = Align.CENTER;
		infec_button.halign = Align.CENTER;
		hbox4.halign = Align.CENTER;
		label_var.halign = Align.CENTER;
		hbox1.halign = Align.CENTER;
		hbox2.halign = Align.CENTER;
		hbox3.halign = Align.CENTER;
		label_edo.halign = Align.CENTER;
		statusbar.halign = Align.CENTER;
		
		controles.add(size_label);
		controles.add(size_button);
		// controles.add(mostrar_espacio);
		controles.add(empty1);
		controles.add(infec_label);
		controles.add(infec_button);
		controles.add(hbox4);
		controles.add(empty2);
		controles.add(label_var);
		controles.add(hbox1);
		controles.add(hbox2);
		controles.add(hbox3);
		controles.add(empty3);
		controles.add(label_edo);
		controles.add(statusbar);
		
		eval = new Evaluador[4];
		content.show();
		add(content);
	}
	
	public void show_graphic () {
		if (running)
			on_play_pause_clicked();
		
		if (dialog != null)
			dialog.destroy();
		
		int r_a = r_a_button.get_value_as_int();
		int r_b = r_b_button.get_value_as_int();
		int lag = lag_button.get_value_as_int();
		
		dialog = new GraphicDialog(this, running_time, r_a, r_b, lag);
		dialog.set_lists(density_list_alive,density_list_inf,density_list_dead);
		dialog.present();
	}

	private void init_lattice () {
		if (!init) {
			play_pause_button.sensitive = true;
			clean_button.sensitive = true;
			
			double chance = infec_button.get_value();
			int size = size_button.get_value_as_int();
			
			lattice = new Lattice(size, chance);
			generate_button.sensitive = false;
			
			for (int i = 0; i < 4; i++) 
				eval[i] = new Evaluador(ref lattice, i + 1);
			
			lattice.halign = Align.CENTER;
			lattice.valign = Align.CENTER;
			
			scroll.add(lattice);
			if (mostrar_espacio.active) 
				lattice.show();
			
			refresh_status(OperationType.GENERATED);
			init = true;
		}
	}

	private void on_clean_clicked () {
		if (lattice != null) {
			scroll.remove(scroll.get_child());
			lattice.destroy();
		}
		
		density_list_alive.foreach((entry) => {
			density_list_alive.remove(entry);
		});
		
		density_list_inf.foreach((entry) => {
			density_list_inf.remove(entry);
		});
		
		density_list_dead.foreach((entry) => {
			density_list_dead.remove(entry);
		});
		
		play_pause_button.sensitive = false;
		generate_button.sensitive = true;
		clean_button.sensitive = false;

		refresh_status(OperationType.CLEANED);
		init = false;
	}

	private void on_play_pause_clicked () {
		if (running) {
			play_pause_button.remove(pause_img);
			play_pause_button.add(play_img);

			refresh_status(OperationType.PAUSED);
			clean_button.sensitive = true;
			running = false;
		} else {
			play_pause_button.remove(play_img);
			play_pause_button.add(pause_img);
			
			if (dialog != null) dialog.hide();

			clean_button.sensitive = false;
			running = true;
			run();
		}
	}

	private void refresh_status (OperationType operation) {
		string status = "Células sanas: %.2f %c\n".
			printf(lattice.density_alive, '%') +
			"Células infectadas: %.2f %c\n".
			printf(lattice.density_inf, '%') +
			"Células muertas: %.2f %c\n".
			printf(lattice.density_dead, '%');
		
		switch (operation) {
			default:
			case OperationType.IDLE:
			case OperationType.CLEANED:
				running_time = 0;
				statusbar.label = "Esperando... ";
				break;
			case OperationType.GENERATED:
				running_time = 0;
				statusbar.label = "Espacio generado. \n" + 
					"Infección inicial: %.2f %c".
					printf(infec_button.get_value(), '%');
				break;
			case OperationType.RUNNING:
				statusbar.label = status;
				if ((lattice.density_alive < 25) && (running_time > 20)) {
					statusbar.label += 
						"\n<b><i>El paciente adquirió SIDA.</i></b>";
				}
				 
				statusbar.label += "\n%d iteraciones (Corriendo).".
					printf(running_time);
					
				density_list_alive.append(lattice.density_alive);
				density_list_inf.append(lattice.density_inf);
				density_list_dead.append(lattice.density_dead);
				break;
			case OperationType.PAUSED:
				statusbar.label = status;
				if ((lattice.density_alive < 25) && (running_time > 20)) {
					statusbar.label += 
						"\n<b><i>El paciente adquirió SIDA.</i></b>";
				}
				 
				statusbar.label += "\n%d iteraciones (Pausado).".
					printf(running_time);
				break;
			case OperationType.STOPPED:
				statusbar.label = status;
				if ((lattice.density_alive < 25) && (running_time > 20)) {
					statusbar.label += 
						"\n<b><i>El paciente adquirió SIDA.</i></b>";
				}
				 
				statusbar.label += "\n%d iteraciones (Detenido).".
					printf(running_time);
				break;
		}
	}	

	private void run () {
		int r_a = r_a_button.get_value_as_int();
		int r_b = r_b_button.get_value_as_int();
		int lag = lag_button.get_value_as_int();
			
		GLib.Timeout.add(250,() => {
			if (running_time == 250) {
				if (running) on_play_pause_clicked();
				refresh_status(OperationType.STOPPED);
				play_pause_button.sensitive = false;
			}
			
			if (running) {
				lattice.r_a = r_a;
				lattice.r_b = r_b;
				lattice.lag = lag;
				
				try {
					Thread<void *>[] thread = new Thread<void *>[4];
					
					for (int i = 0; i < 4; i++) {
						thread[i] = new Thread<void *>.try(
							"Sector %d".printf(i + 1), eval[i].run
						);
					}
					
					for (int i = 0; i < 4; i++) 
						thread[i].join();
						
					for (int i = 0; i < 4; i++) {
						thread[i] = new Thread<void *>.try(
							"Sector %d".printf(i + 1), eval[i].refresh
						);
					}
					
					for (int i = 0; i < 4; i++) 
						thread[i].join();
				} catch (Error e) {
					stderr.printf("%s\n", e.message);
					running = false;
					return false;
				}
				
				running_time++;
				if (mostrar_espacio.active) {
					lattice.hide();
					lattice.show();
				}

				refresh_status(OperationType.RUNNING);
			}

			return running;
		});
	}
}
