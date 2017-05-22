//: Playground - noun: a place where people can play

import UIKit

//: The DatePolicy enum defines how the MonthlyPaymentStream should adjust dates
//: when it adds the payments to the monthly bucket. This is the Policy object in
//: the Strategy pattern.

enum DatePolicy
	{
    case end
    case start
    }

//: This is a quick hack for calcuating days in a month. Don't do this

var DaysInMonth:[Int] = [31,28,31,30,31,30,31,31,30,31,30,31]

//: Some crude extensions to date to assist in some date calculations. 
//: These are purely a quick hack, and should not be used generally.

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

//: A Payment is a sinple struct for holding some information about payments. It can
//: also do some simple operations such as adding payments. Purely for demonstration purposes.

struct Payment
	{
    private static let Formatter = initDateFormatter()
    
    private static func initDateFormatter() -> DateFormatter
    	{
        let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy/MMM/dd HH:mm:SS ZZZ"
        return(dateFormatter)
        }
    
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
        let dateString = Payment.Formatter.string(from:date)
        Swift.print("\(dateString) \(amount)")
        }
    }

//: A definition of an abstract PaymentStream, this is similar to an interface in Java. It defines
//: two operations one for retrieving the next available payment from a stream, and one for resetting
//: the current offset of a stream.

protocol PaymentStream
	{
    func nextPayment() -> Payment?
    func resetOffset()
    }

//: A PaymentArray defines a very simple collection of payments that can be added to 
//: and that one can access by asking for the next payment. A PaymentArray implements
//: the PaymentStream protocol, this means it can be used anywhere a PaymentStream is expected.

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
    
    func resetOffset()
    	{
        offset = 0
        }
    
    func print()
    	{
        resetOffset()
        var payment = nextPayment()
        while payment != nil
        	{
            payment?.print()
            payment = nextPayment()
            }
        }
    }

//: Create a payment array and add some payments to it.

let stream = PaymentArray()
var date = Date()
stream.addPayment(date:date,amount:20)
date = date.withDaysAdded(1)
stream.addPayment(date:date,amount:30)
date = date.withDaysAdded(23)
stream.addPayment(date:date,amount:50)
date = date.withDaysAdded(12)
stream.addPayment(date:date,amount:10)

//: Ask the payment array to print itself so we can see it's contents.

stream.print()

//: Now we define a MonthlyPaymentStream, which will wrap ( or decorate ) any PaymentStream. The MonthlyPaymentStream
//: assumes that the payments that come out of the PaymentStream are ordered according to date. It merges multiple payments
//: for a month into a single payment in the payment stream. The DatePolicy defines whether the date for the monthly payment
//: is adjusted to the start of the month or the end of the month. In essence the MonthlyPaymentStream can wrap any PaymentStream
//: and bucket multiple payments in a month into a single monthly payment, this demonstrates the use of the Decorator ( or Wrapper )
//: design pattern. The DatePolicy used in conjunction with the MonthlyPaymentStream demonstates the use of the Strategy pattern. In essence
//: the DatePolicy causes the algorithm used to adjust the monthly date to vary independently of the implementation. We can get different behavior from the
//: MonthlyPaymentStream merely by changing the DatePolicy.

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
    
    func resetOffset()
    	{
        source.resetOffset()
        }
    
    func print()
    	{
        resetOffset()
        var payment = nextPayment()
        while payment != nil
        	{
            payment?.print()
            payment = nextPayment()
            }
        }
    }

print("------------------------")

//: So now we wrap the payment array ( named stream ) with a MonthlyPaymentStream. This works because
//: PaymentArray implements the PaymentStream protocol ( we can wrap any object as long as it adheres to 
//: the PaymentStream protocol ). Now we can ask the MonthlyPaymentStream to print itself out, it uses it's
//: own nextPayment method to iterate over it's content. In so doing we now receive a stream on monthly payments
//: rather than the payments that we added to the PaymentArray. Notice that the dates displayed are adjusted to 
//: the 1st of the month that contains the payment. This is controlled by the DatePolicy value. Changing the datePolicy
//: of the MonthlyPaymentStream changes the way the dates are adjusted ( Strategy or Policy pattern ).

let monthlyPaymentStream = MonthlyPaymentStream(on: stream)
monthlyPaymentStream.print()
print("------------------------")

//: Here's where we change the policy, and note the different output from the MonthPaymentStream.print method.

monthlyPaymentStream.datePolicy = .end
monthlyPaymentStream.print()

