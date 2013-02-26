
class ProjectChooserGUI < ProjectChooserView

	include GladeGUI

	def initialize(parent)
		@parent = parent
		@parent.proj_path = nil
		super()
		load_glade(__FILE__) #don't set parent here! Want modal window.
	end
	
	def show()	
#		@builder["window1"].resize( 700, 760)
		@builder["scrolledwindowProjTree"].add(self)  
		refresh(false)
		show_window()
	end
 
	def buttonOpen__clicked(*args)
		return unless row = selected_rows.first
		@parent.proj_path = row[:file_name]
		destroy_window()
	end

	def buttonSelect_clicked
		if folder = VR::Dialog.folder_box(@builder)
  		@parent.proj_path = folder
  		destroy_window()			
		end
	end

	def checkBackup_toggled
		refresh(@builder["checkBackup"].active?)
	end	

	def self__row_activated(*args)
		buttonOpen__clicked
	end


end
