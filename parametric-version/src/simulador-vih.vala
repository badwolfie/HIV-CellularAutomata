using Gtk;

public class SimuladorVIH : Gtk.Application {
	private VentanaSimulador ventana;

	private const GLib.ActionEntry[] app_entries = {
		{ "graphic", graphic_cb, null, null, null }, 
		{ "about", about_cb, null, null, null }, 
		{ "quit", quit_cb, null, null, null }, 
	};

	public SimuladorVIH () {
		Object(application_id: "badwolfie.sim-vih.app", 
		   flags: ApplicationFlags.NON_UNIQUE);
	}

	protected override void startup () {
		base.startup();

		add_action_entries(app_entries, this);
		ventana = new VentanaSimulador(this);

		var builder = new Builder();
		try {
			builder.add_from_file("data/menus.ui");
		} catch (Error e) {
			error("Error al cargar el menu: %s", e.message);
		}

		var appmenu = builder.get_object("appmenu") as MenuModel;
		set_app_menu(appmenu);
	}

	protected override void activate () {
		base.activate();
		ventana.present();
	}

	protected override void shutdown () {
		base.shutdown();
	}

	private void graphic_cb () {
		ventana.show_graphic();
	}

	private void about_cb () {
		string[] authors = { "Ian Hernández <ihernandezs@openmailbox.org>" };

        string comments = "Implementación en Vala y GTK+ del\nautómata celular ";
        comments += "\"Simulador VIH\".";

        Gtk.show_about_dialog(ventana,
			"program-name", ("Simulador VIH"),
			"title","Acerca del Simulador VIH",
			"copyright", ("Copyright \xc2\xa9 2015 Ian Hernández"),
			"comments",(comments),
			"logo-icon-name", "chrome-app-list",
			"authors", authors,
			"version", "1.0.0"
		);
	}

	private void quit_cb () {
		ventana.destroy();
	}

	public static int main (string[] args) {
		if (!Thread.supported()) {
			stderr.printf ("Threads are not supported!\n");
			return -1;
		}
	
		Gtk.Window.set_default_icon_name("chrome-app-list");
		var app = new SimuladorVIH();
		return app.run(args);
	}
}
