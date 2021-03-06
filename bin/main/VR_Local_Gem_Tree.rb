
class VR_Local_Gem_Tree < GemTree

	include GladeGUI
	
	def initialize(main)
		super()
		@main = main
#		set_title(PIX => "Gems on this Computer")
		load_glade(__FILE__)
	end
	
	def refresh()
		self.model.clear
		result = `gem list`
		result.each_line do |line|
			gem, versions = get_name_ver(line)
			versions.split(",").each do |v|
				add_row( :pix => RUBY_ICON, :gem => "#{gem} (#{v})" )
			end
		end
	end


	#todo
	def popViewSpec_clicked; 
		gem, ver = selected_gem()
		spec = `gem specification #{gem} -v #{ver}`
		@main.tabs.load_tab()
		@main.tabs.set_contents(spec)	
	end

	def popOpenRubygemsPage_clicked
		gem, ver = selected_gem()
		VR_Tools.popen("#{$VR_ENV.browser} http://rubygems.org/gems/#{gem}")
	end

	def popOpenHomepage_clicked 
		gem, ver = selected_gem()
		spec = `gem specification #{gem} -v #{ver}` 
		match = /^homepage:\s+(.*)$/.match(spec)
		VR_Tools.popen("#{$VR_ENV.browser} #{match[1]}")
	end

	def popUninstall_clicked
		gem, ver = selected_gem()
		begin
			Gem::Uninstaller.new(gem, {:version => ver, :executables => true }).uninstall()
			txt = "Uninstalled Gem:  #{gem} #{ver}"
		rescue
  		command = "gem uninstall #{gem} -x -v '#{ver}' 2>&1" 		
  		txt = VR_Tools.sudo_command(command)
		end		
		@main.shell.buffer.text = txt
		refresh()
	end


#	def popUninstall_clicked
#		gem, ver = selected_gem()
#		#command = "gem uninstall " + gem_name.gsub("("," -x -v ").gsub(")","")
#		command = "gem uninstall #{gem} -x -v '#{ver}' 2>&1" 		
#		@main.shell.buffer.text = VR_Tools.sudo_command(command)
#		refresh()
#	end

#	def get_name_ver(line)
#		match = /^(.*)\s+\((.*)\)/.match(line)
#		return match[1], match[2]
#	end

	def selected_gem
		row = self.selection.selected[1].split(" (")
		ver = row[1].gsub(")","")
		return row[0], ver
	end

end


