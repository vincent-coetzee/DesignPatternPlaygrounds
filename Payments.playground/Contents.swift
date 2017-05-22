//: Playground - noun: a place where people can play

import UIKit

enum DatePolicy
	{
    case end
    case start
    }

var DaysInMonth:[Int] = [31,28,31,30,31,30,31,31,30,31,30,31]

extension Date
	{
    func withDaysAdded(_ days:Int) -> Date
    	{
        let components = DateComponents(day:days)
        let calendar = NSCalendar(identifier: .gregorian)
        return(calendar!.date(byAdding:components,to:self))!
        }
    
    func startOfMonth() -> Date
    	{
        let calendar = NSCalendar(identifier: .gregorian)!
        let month = calendar.component(.month,from: self) - 1
        let year = calendar.component(.year,from: self)
        let components = DateComponents(year:year,month:month+1,day:1)
        let newDate = calendar.date(from:components)!
        return(newDate)
        }
    
    func endOfMonth() -> Date
    	{
        let calendar = NSCalendar(identifier: .gregorian)!
        let month = calendar.component(.month,from: self) - 1
        let year = calendar.component(.year,from: self)
        var days = DaysInMonth[month]
        if year % 4 == 0
        	{
            days += 1
            }
        let components = DateComponents(year:year,month:month+1,day:days)
        let newDate = calendar.date(from:components)!
        return(newDate)
        }
    }

let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy/MMM/dd HH:mm:SS ZZZ"

struct Payment
	{
    let date:Date
    let amount:Int
    
    var month:Int
    	{
        let calendar = NSCalendar(identifier: .gregorian)!
        let components = calendar.components(.month,from: date)
        return(components.month!)
        }
    
    init(date:Date,amount:Int)
    	{
        self.date = date
        self.amount = amount
        }
    
    func payment(byAdding:Payment) -> Payment
    	{
        let newAmount = amount + byAdding.amount
        return(Payment(date:date,amount:newAmount))
        }
    
    func print()
    	{
        let dateString = dateFormatter.string(from:date)
        Swift.print("\(dateString) \(amount)")
        }
    }

protocol PaymentStream
	{
    func nextPayment() -> Payment?
    func reset()
    }

class PaymentArray:PaymentStream
	{
    private var payments:[Payment] = []
    private var offset:Int = 0
    
    func addPayment(date:Date,amount:Int)
    	{
        payments.append(Payment(date:date,amount:amount))
        }
    
    func nextPayment() -> Payment?
    	{
        if offset < payments.count
        	{
            let payment = payments[offset]
            offset += 1
            return(payment)
            }
        return(nil)
        }
    
    func reset()
    	{
        offset = 0
        }
    
    func print()
    	{
        reset()
        var payment = nextPayment()
        while payment != nil
        	{
            payment?.print()
            payment = nextPayment()
            }
        }
    }

let stream = PaymentArray()
var date = Date()
stream.addPayment(date:date,amount:20)
date = date.withDaysAdded(1)
stream.addPayment(date:date,amount:30)
date = date.withDaysAdded(23)
stream.addPayment(date:date,amount:50)
date = date.withDaysAdded(12)
stream.addPayment(date:date,amount:10)
stream.print()

class MonthlyPaymentStream:PaymentStream
	{
    private let source:PaymentStream
    private var currentPayment:Payment?
    
    public var datePolicy = DatePolicy.start
    
    init(on:PaymentStream)
    	{
        source = on
        }
    
    private func adjust(date:Date,for policy:DatePolicy) -> Date
    	{
        switch(policy)
        	{
        case(.start):
        	return(date.startOfMonth())
        case(.end):
        	return(date.endOfMonth())
            }
        }
    
    func nextPayment() -> Payment?
    	{
        var total:Payment
        
        if currentPayment == nil
        	{
            currentPayment = source.nextPayment()
            }
        if currentPayment == nil
        	{
            return(nil)
            }
        total = currentPayment!
        currentPayment = source.nextPayment()
        while currentPayment != nil && currentPayment!.month == total.month
        	{
            total = total.payment(byAdding: currentPayment!)
            currentPayment = source.nextPayment()
            }
        let totalDate = adjust(date:total.date,for: datePolicy)
        total = Payment(date:totalDate,amount:total.amount)
        return(total)
        }
    
    func reset()
    	{
        source.reset()
        }
    
    func print()
    	{
        reset()
        var payment = nextPayment()
        while payment != nil
        	{
            payment?.print()
            payment = nextPayment()
            }
        }
    }

print("------------------------")
let monthlyPaymentStream = MonthlyPaymentStream(on: stream)
monthlyPaymentStream.print()
print("------------------------")
monthlyPaymentStream.datePolicy = .end
monthlyPaymentStream.print()

