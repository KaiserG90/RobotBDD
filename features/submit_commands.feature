Feature: submit the commands
	As a player
	I want to submit the commands
	So that I can play with the robot

	Scenario Outline: robot is not on table and is moved or rotated
		Given the robot is not on the table
		When the command is "<command>"
		Then the robot will ignore the command 
		Scenarios: illegal commands
			| command | 
			| MOVE    |
			| RIGHT   |
			| LEFT    |

	Scenario Outline: placing robot on the table
		Given the robot is not on the table
		When the command is PLACE "<x>","<y>","<facing>"
		Then the robot should be placed on the table
		Examples: 
			| x | y | facing | 
			| 0 | 0 | NORTH  |
			| 0 | 1 | EAST   |
			| 2 | 3 | WEST   |

	Scenario Outline: cannot move the robot cause it would fall
		Given the robot is on the table
			And the robot is facing "<direction>"
			And the robot is on "<direction>" edge
		When the command is "MOVE" 
		Then the robot will ignore the command 
		Scenarios: illegal command
			| direction | 
			| NORTH     |
			| EAST      |
			| SOUTH     | 
			| WEST      |

	Scenario Outline: can move the robot
		Given the robot is on the table
		When the command is "MOVE" 
			And the robot is facing "<direction>"
			But the robot is not on "<direction>" edge
		Then the robot should move 
		Scenarios: legal command
			| direction | 
			| NORTH     |
			| EAST      |
			| SOUTH     | 
			| WEST      |

	Scenario Outline: rotate the robot 
		Given the robot is on the table
			And the robot is facing "<facing>"
		When the command is "<command>"
		Then the robot should be facing "<new_facing>"
		Scenarios:
			| facing | command | new_facing |
			| NORTH  | LEFT   | WEST       |
			| EAST   | LEFT   | NORTH      |
			| SOUTH  | LEFT   | EAST       |
			| WEST   | LEFT   | SOUTH      |
			| NORTH  | RIGHT  | EAST       |
			| EAST   | RIGHT  | SOUTH      |
			| SOUTH  | RIGHT  | WEST       |
			| WEST   | RIGHT  | NORTH      |