
class ProjectChooserView < VR::ListView

	PIX = Gdk::Pixbuf.new(File.dirname(__FILE__) + "/../../img/folder.png")

	def initialize()
		super(:folder => {:pix => Gdk::Pixbuf, :file_name => String}, :modified => DateTime) 
		ren_xalign(:modified => 1)
		col_xalign(:modified => 1)
		col_sort_column_id(:modified => id(:modified), :pix => id(:file_name))
	end

	def refresh(show_backup = false)
		model.set_sort_column_id(1)
		self.model.clear
		Dir.glob(File.join(ENV["HOME"], "visualruby", "**", VR_ENV::SETTINGS_FILE)).each do |fn|
			next if not show_backup and fn =~ / Backup /  
			next if show_backup and not fn =~ / Backup / 
			t = File.stat(fn).mtime
			row = add_row()
			row[:pix] = PIX
			row[:file_name] = File.dirname(fn)
			row[:modified] = DateTime.parse(t.to_s)
		end	
		model.set_sort_column_id(id(:modified), Gtk::SORT_DESCENDING)
	end	
	
end


#		s = Gtk::ListStore.new(DateTime)
#		s.set_sort_func(0) { |x,y| x[0] <=> y[0]} 
#		v = Gtk::TreeView.new(s)
#		col = Gtk::TreeViewColumn.new()
#		r = Gtk::CellRendererText.new()
#  	col.pack_start( r, false )
#  	col.set_cell_data_func(r) do |col, ren, model, iter|
#  			ren.text = iter[0].to_s
#  	end
#		v.append_column(col)
#
#		col.sort_column_id = 0
#		s.set_sort_column_id(0)
#		row = s.append
#	  row[0] = DateTime.now
#		row = s.append
#	  row[0] = DateTime.now
