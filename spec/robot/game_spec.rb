require 'spec_helper'

module Robot
	describe Game do 
		let(:output){ double('output').as_null_object }
		let(:game) { game = Game.new(output) }

		describe "#submit_command" do
			it "should ignore the command cause there is no robot on the table" do
				game.submit_command('MOVE')
				expect(output).not_to receive(:puts).with(/Output:/)				
				game.submit_command('REPORT')
			end
			
			it "should send a message with the report" do
				game.submit_command('PLACE 0,0,NORTH')
				expect(output).to receive(:puts).with('Output: 0,0,NORTH')
				game.submit_command('REPORT')
			end

			it "should place the robot on the table" do
				game.submit_command('PLACE 0,0,NORTH')
				expect(output).to receive(:puts).with('Output: 0,0,NORTH')
				game.submit_command('REPORT')
			end

			it "should ignore the command cause the robot is going to fall" do
				game.submit_command('PLACE 0,0,SOUTH')
				game.submit_command('MOVE')
				expect(output).to receive(:puts).with('Output: 0,0,SOUTH')
				game.submit_command('REPORT')
			end

			it "should move the robot" do
				game.submit_command('PLACE 1,1,WEST')
				game.submit_command('MOVE')
				expect(output).to receive(:puts).with('Output: 0,1,WEST')
				game.submit_command('REPORT')
			end

			it "should right rotate the robot" do
				game.submit_command('PLACE 2,2,NORTH')
				game.submit_command('RIGHT')
				expect(output).to receive(:puts).with('Output: 2,2,EAST')
				game.submit_command('REPORT')
			end

			it "should left rotate the robot" do
				game.submit_command('PLACE 2,2,NORTH')
				game.submit_command('LEFT')
				expect(output).to receive(:puts).with('Output: 2,2,WEST')
				game.submit_command('REPORT')
			end
		end
	end
end