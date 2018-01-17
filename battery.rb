require 'green_shoes'

SAVE_INITIAL_TIME = `gsettings get org.gnome.desktop.session idle-delay`.freeze

def window
  Shoes.app title: 'Battery', width: 450, height: 300 do
    para 'Battery Information:', margin: 10
    @info = para width: 400, margin: 10
    para
    para 'Set display idle time (s):', margin: 10
    @input = edit_line width: 400, margin: 10
    @button = button ' Accept ', margin: 10
    Thread.new do
      loop do
        text = `acpi`.delete("\n")
        @info.text = text 
        sleep 1
      end
    end
    @button.click do
      i = @input.text.to_i
      puts i
      if i <= 0 then
        alert 'Enter positive number'
      else
        `gsettings set org.gnome.desktop.session idle-delay #{i}`
      end
    end
  end
end

time = SAVE_INITIAL_TIME
time = time.split(' ').last
window
`gsettings set org.gnome.desktop.session idle-delay #{time}`
