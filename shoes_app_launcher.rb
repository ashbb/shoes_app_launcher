# shoes_app_launcher.rb

Shoes.app title: 'Shoes app launcher', width: 250, height: 350 do
  background tan
  style Link, fill: nil, underline: nil, stroke: saddlebrown
  style LinkHover, fill: nil, underline: nil, weight: 'bold'

  default = File.join DIR, 'samples'
  
  add_lists = proc do |folder|
    folder ||= default
    @slot.clear if @slot
    @list_area.append do
      @slot = stack do
        Dir.glob(File.join folder, '*').each do |file|
          para link(File.basename file){
            Dir.chdir(folder){eval IO.read(file), TOPLEVEL_BINDING}
          } if File.extname(file) == '.rb'
        end
      end
    end
  end
  
  inscription link('stop', stroke: white){|s| @stop = !@stop; s.text = @stop ? 'restart' : 'stop'}
  
  tagline link('change folder', stroke: crimson){
    folder = ask_open_folder
    add_lists[folder]
  }, align: 'center'

  @list_area = stack height: 300, scroll: true
  add_lists[]
  
  creatures = []
  Dir.glob('creatures/*.png').each.with_index do |c, i|
    creatures << image(c, width: 20, height: 20, top: 40*i, left: 40*i, vx: 3, vy: 4)
  end
  
  animate do
    begin
      w, h = self.width, self.height
      creatures.each do |c|
        nx, ny = 0, 0
        vx, vy =  c.style[:vx], c.style[:vy]
        nx, ny = c.left + vx, c.top + vy
        c.style(vx: -vx)  if nx + 20 > w or nx < 0
        c.style(vy: -vy)  if ny + 20 > h or ny < 0
        c.move nx, ny
      end
    end unless @stop
  end
end
