//: Playground - noun: a place where people can play

import UIKit

protocol Visitor
	{
    func visit(member:Member)
    func visit(payment:Payment)
    }

class Payment
	{
    let date:Date
    let amount:Int
    
    init(date:Date,amount:Int)
    	{
        self.date = date
        self.amount = amount
        }
    
    func visit(visitor:Visitor)
    	{
        visitor.visit(payment:self)
        }
    }

class Member
	{
    let name:String
    let payments:[Payment]
    
    init(name:String,payments:[Payment])
    	{
        self.name = name
        self.payments = payments
        }
    
    func visit(visitor:Visitor)
    	{
        visitor.visit(member:self)
        for payment in payments
            {
            payment.visit(visitor:visitor)
            }
        }
	}

class PrintingVisitor:Visitor
	{
    func visit(member:Member)
    	{
        print(member.name)
        }
    
    func visit(payment:Payment)
    	{
        print(payment.date)
        print(payment.amount)
        }
    }

class AddingVisitor:Visitor
    {
    var total:Int = 0
    
    func visit(member:Member)
    	{
        }
    
    func visit(payment:Payment)
    	{
        total += payment.amount
        }
    }

let payments = [Payment(date:Date(),amount:100),Payment(date:Date(),amount:200)]
let member = Member(name:"Joe",payments:payments)

let printer = PrintingVisitor()
member.visit(visitor:printer)
let adder = AddingVisitor()
member.visit(visitor:adder)
print(adder.total)
