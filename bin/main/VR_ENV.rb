
class VR_ENV

	include GladeGUI

	SETTINGS_FILE = ".vr_settings.yaml"

	attr_accessor :browser, :width, :height, :backup_path, :panel_pos, :tab_spaces
	attr_accessor :run_command_line, :open_files, :open_folders, :current_file, :glade_path
	attr_accessor :font_name, :rdoc_command_line

	def initialize()
		@browser = "firefox"
		@width = 800
		@height = 600
		@panel_pos = 360
		@backup_path = ENV["HOME"]
		@tab_spaces = 2
		@run_command_line = "ruby main.rb"
		@open_files = []
		@open_folders = []
		@current_file = ""
		save_yaml()		
	end


	def show()
		load_glade(__FILE__)
		@glade_box = VR::SimpleComboBoxEntry.new(@glade_path, "glade", "glade-3", "C:\\Program Files (x86)\\Gtk+\\bin\\glade-3")
		@builder["hboxGlade"].add(@glade_box) 
		@browser_box = VR::SimpleComboBoxEntry.new(@browser, "xdg-open", "firefox", "google-chrome", "chrome", "chromium", "iexplore", "start iexplore", "start firefox", "start google-chrome", "start chrome", "start chromium", "C:\\Program Files\\iexplorer\\iexplore.exe")
		@builder["hboxBrowser"].add(@browser_box)
		set_glade_variables(self)
#		@builder["font_namex"].font_name = @font_name
		@builder["font_name"].show_size = true
		@builder["window1"].resize 580, 300
		show_window()
	end

	#todo validate
	def buttonSave_clicked
		get_glade_variables
		spaces = @builder['VR_ENV.tab_spaces'].text.to_i
		@tab_spaces = spaces if spaces > 0 and spaces < 9
		@glade_path = @glade_box.active_text
		@browser = @browser_box.active_text 
		save_yaml()
		destroy_window()
	end

	def buttonChooseFolder_clicked
		if folder = VR::Dialog.folder_box(@builder)
			if folder =~ /^#{Dir.pwd}\b/
				VR::Dialog.message_box("You must select a backup path outside the project's root folder.")
			else	
				@builder['backup_path'].text = folder
			end
		end	
	end

	def self.load_yaml()
		if File.file?(SETTINGS_FILE) 
		 	YAML::load(File.open(SETTINGS_FILE).read).save_yaml() #update format
		else
	  	VR_ENV.new()
		end
	end

	def save_yaml()
		@glade_path ||= "glade-3"  #correct for old format!
		@font_name ||= "Monospace 10"
		@rdoc_command_line ||= "rdoc -x README"
		@backup_path = ENV["HOME"] unless File.directory?(@backup_path)
		data = YAML.dump(self)
		File.open(Dir.pwd + "/" + SETTINGS_FILE, "w") {|f| f.puts(data)}
		return self
	end

	def buttonTryGlade__clicked(*argv)
		VR_Tools.popen(@glade_box.active_text)
	end

	def buttonTryBrowser__clicked(*argv)
		VR_Tools.popen(@browser_box.active_text)
	end

end
