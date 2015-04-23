class Output
	def messages
		@messages ||= []
	end

	def puts(message)
		messages << message
	end
end

def my_output
	@output ||= Output.new
end


Given /^the robot is not on the table$/ do
	@game = Robot::Game.new(my_output)
end

When /^the command is "([^"]*)"$/ do | command |
	if command=="MOVE" && @x && @y && @facing
		@game.submit_command("PLACE #{@x},#{@y},#{@facing}")
	elsif (command=="RIGHT" || command=="LEFT") && @x && @y && @facing
		@game.submit_command("PLACE #{@x},#{@y},#{@facing}")
	end
	@game.submit_command(command)
end

Given /^the position is "(.*?)","(.*?)"$/ do |x,y|
	@x=x
	@y=y
end

When /^the command is PLACE "(.*?)","(.*?)","(.*?)"$/ do |x,y,facing|
	@game.submit_command("PLACE #{x},#{y},#{facing}")
end
Then /^the robot should be placed on the table$/ do
	#expect(output.messages)
end

Then /^the robot will ignore the command$/ do
end 

Given /^the robot is on the table$/ do
	@game = Robot::Game.new(my_output)
	@x=2
	@y=2
end

And /^the robot is facing "([^"]*)"$/ do |facing|
	@facing = facing
end

And /^the robot is on "([^"]*)" edge$/ do |facing|
	@x=0
	@y=0
	case facing
	when 'NORTH' then @y=5
	when 'EAST' then @x=5
	when 'SOUTH' then @x=0
	when 'WEST' then @x=0
	end
end
	

But /^the robot is not on "([^"]*)" edge$/ do |facing|
	@game.submit_command('PLACE 1,2,#{facing}')
end
Then /^the robot should move$/ do
	@game.submit_command("PLACE #{@x},#{@y},#{@facing}")
	@game.submit_command('REPORT')
	@game.submit_command('MOVE')
	@game.submit_command('REPORT')
	nr_messages = my_output.messages.length
	expect(my_output.messages[nr_messages-1]).not_to eq(my_output.messages[nr_messages-2])
end

Then /^the robot should be facing "([^"]*)"$/ do | facing |
	@game.submit_command('REPORT')
	expect(my_output.messages).to include("Output: #{@x},#{@y},#{facing}")
end