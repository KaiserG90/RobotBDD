class Numeric
  def to_rad
    self * Math::PI / 180 
  end
end

module Robot
	class Game
		def initialize(output)
			@output = output
			@robot = Robot.new
			@table = Table.new
		end

		def submit_command(cmd)
			if(@robot.is_on_table)
				case cmd
				when 'REPORT' then @robot.report(@output)
				when 'MOVE' then @robot.move
				when 'LEFT' then @robot.left
				when 'RIGHT' then @robot.right
				end
			elsif cmd =~ /PLACE (\d),(\d),([A-Z]+)/
				@robot.place_on_table(@table,$1,$2,$3)
			end
		end
	end

	class Robot
		@@directions = {
			EAST: 0,
			NORTH: 90,
			WEST: 180,
			SOUTH: 270 
		}

		attr_accessor :is_on_table
		attr_accessor :x
		attr_accessor :y
		attr_accessor :facing
		
		def place_on_table(table,x,y,facing)
			@x = x.to_i
			@y  = y.to_i
			@facing = facing.chomp
			@table = table
			@table.add_robot(self)
			@is_on_table = true
		end

		def report(output)
			output.puts "Output: #{@x},#{@y},#{@facing}"
		end

		def move
			new_x = @x + Math.cos(@@directions[@facing.to_sym].to_rad).round(0)
			new_y = @y + Math.sin(@@directions[@facing.to_sym].to_rad).round(0)
			if @table.admissible_place_for(new_x,new_y)
				@x = new_x
				@y = new_y 
			else
				return "Error: the robot is going to fall" 
			end
		end

		def right
			degree = (@@directions[@facing.to_sym]-90)%360
			@facing = @@directions.invert[degree]
		end

		def left
			degree = (@@directions[@facing.to_sym]+90)%360
			@facing = @@directions.invert[degree]
		end
	end

	class Table
		attr_reader :width
		attr_reader :height
		attr_reader :pieces

		def initialize(width=5,height=5)
			@width = width
			@height = height
		end

		def add_robot(robot)
			@robot = {
				x: robot.x,
				y: robot.y,
				facing: robot.facing
			}
		end

		def admissible_place_for(new_robot_x, new_robot_y)
			if new_robot_x >= self.width || new_robot_y >= self.height || new_robot_x < 0 || new_robot_y < 0
				false	
			else
				true
			end
		end
	end
end