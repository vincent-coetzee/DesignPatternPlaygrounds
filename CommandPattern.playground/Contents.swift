//: Playground - noun: a place where people can play

import UIKit

enum Direction
	{
    case north
    case south
    case east
    case west
    
    func directionAfterApplying(command:Command) -> Direction
    	{
        return(command.directionAfterApplying(direction:self))
        }
    }

class Rover
	{
    var direction:Direction = .north
    var executedCommands:[Command] = []
    
    func executeCommandSequence(commands:[Command])
    	{
        executedCommands = []
        for command in commands
            {
     		command.executeAgainst(rover:self)
            direction = direction.directionAfterApplying(command: command)
            }
        print(direction)
        transmitLogToHouston(commands:executedCommands)
        }
    
	func moveForward()
    	{
        print("FORWARD")
        executedCommands.append(MoveCommand())
        }
    
	func rotateRight()
    	{
        print("RIGHT")
        executedCommands.append(RotateRightCommand())
        }
    
    func rotateLeft()
    	{
        print("LEFT")
        executedCommands.append(RotateLeftCommand())
        }
    
    func takePhoto()
    	{
        print("SMILE MARS!")
        executedCommands.append(TakePhotoCommand())
        }
    
    func transmitLogToHouston(commands:[Command])
    	{
        var memento:String = ""
            
        for command in commands
            {
            memento = command.appendMemento(to:memento)
            }
        print(memento)
        }
	}

typealias CommandSequence = [Character]

class Command
	{
    class func commandsFrom(sequence:CommandSequence) -> [Command]
    	{
        var commands:[Command] = []
            
        for element in sequence
            {
            switch(element)
                {
            case("M"):
            	commands.append(MoveCommand())
            case("L"):
                commands.append(RotateLeftCommand())
            case("R"):
            	commands.append(RotateRightCommand())
            case("P"):
                commands.append(TakePhotoCommand())
            default:
                commands.append(Command())
                }
            }
        return(commands)
        }
    
    func executeAgainst(rover:Rover)
    	{
        fatalError("Unknown command")
        }
    
	func directionAfterApplying(direction:Direction) -> Direction
    	{
        return(direction)
        }
    
    func appendMemento(to:String) -> String
    	{
        return(to)
        }
	}

class TakePhotoCommand:Command
	{
    override func executeAgainst(rover:Rover)
        {
        rover.takePhoto()
        }
    
    override func appendMemento(to:String) -> String
        {
        return(to + "P")
        }
    }

class MoveCommand:Command
	{
    override func executeAgainst(rover:Rover)
        {
        rover.moveForward()
        }
    
	override func appendMemento(to:String) -> String
        {
        return(to + "M")
        }
	}

class RotateRightCommand:Command
	{
    override func executeAgainst(rover:Rover)
        {
        rover.rotateRight()
        }
    
    override func directionAfterApplying(direction:Direction) -> Direction
        {
        switch(direction)
            {
        case(.north):
            return(.east)
        case(.east):
            return(.south)
        case(.south):
            return(.east)
        case(.west):
            return(.north)
            }
        }
    
    override func appendMemento(to:String) -> String
        {
        return(to + "R")
        }
	}

class RotateLeftCommand:Command
	{
    override func executeAgainst(rover:Rover)
        {
        rover.rotateLeft()
        }
    
	override func directionAfterApplying(direction:Direction) -> Direction
        {
        switch(direction)
            {
        case(.north):
            return(.west)
        case(.east):
            return(.north)
        case(.south):
            return(.east)
        case(.west):
            return(.south)
            }
        }
    
	override func appendMemento(to:String) -> String
        {
        return(to + "L")
        }
	}

let sequence:CommandSequence = ["M","M","M","R","R","M","L","P"]
let rover = Rover()
rover.executeCommandSequence(commands:Command.commandsFrom(sequence:sequence))

let view = UIView(frame:CGRect(x:0,y:0,width:100,height:100))
view.backgroundColor = UIColor.green
