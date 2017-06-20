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
    let payments:[Payment]
    var observers:[Observer] = []
    
    var name:String
    	{
        didSet
        	{
            for observer in observers
                {
                observer.changed(self)
                }
            }
        }
    
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
    
	func add(observer:Observer)
    	{
        observers.append(observer)
        }
    }

protocol Observer
	{
    func changed(_ model:Member)
    }

extension UITextField:Observer
	{
    func changed(_ model:Member)
    	{
        text = model.name
            print(text)
        }
    
    func observe(member:Member)
    	{
        member.add(observer:self)
        }
	}

let member = Member(name:"Joe",payments:[])

let textField = UITextField(frame:CGRect(x:0,y:0,width:100,height:30))

textField.observe(member:member)
member.name = "Joe"
textField
