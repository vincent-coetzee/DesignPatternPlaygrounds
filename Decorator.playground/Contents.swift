//: #### Decorator Pattern
//:
//: Lets say we have a need to display a border around a TextField ( obviously we could do this
//: by turning on the border of the UITextField, but ignore that for the sake of demonstration ). So in
//: this first class, BorderedTextField, we create a subclass of UITextField and we create a border
//: setting the attributes of the subclass. This has the limitation that for every view we want to 
//: put a border around we have to either tweak it in code or create a subclass of the particular view
//: type and turn it's border on. What we want to be able to do is to border any UIView or subclass
//: by means of composition.
//:
//: The [Decorator Pattern](https://en.wikipedia.org/wiki/Decorator_pattern) allows us to do this.

import UIKit

class BorderedTextField:UITextField
	{
    override init(frame:CGRect)
    	{
        super.init(frame:frame)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        }
    
    required init?(coder aDecoder: NSCoder)
    	{
        fatalError("init(coder:) has not been implemented")
    	}
    }

let field = BorderedTextField(frame: CGRect(x:0,y:0,width:100,height:30))
field.text = "hello"

//: First, we create the decorator. In this case it's a view ( called in this instance, BorderedView), that will "decorate" another view
//: with a border. We define a method on the decorator, called wrap, that wraps another view. Another
//: name for the Decorator pattern is the Wrapper pattern, since this is what a decorator does, it
//: wraps one object in another, and adds behavior ( or state ) to the wrapped object.
//:
class BorderedView:UIView
	{
    override init(frame:CGRect)
    	{
        super.init(frame:frame)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        }
    
	required init?(coder aDecoder: NSCoder)
    	{
        fatalError("init(coder:) has not been implemented")
    	}
    
    func wrap(view:UIView)
    	{
        addSubview(view)
        view.frame = self.bounds
        }
    }

//: Now we can take any other view, in this case a UITextField, and we can wrap it in
//: the BorderedView.

let wrappedField = UITextField(frame: CGRect(x:0,y:0,width:100,height:30))
wrappedField.text = "hello"
let borderedView = BorderedView(frame: CGRect(x:0,y:0,width:100,height:30))
borderedView.wrap(view:wrappedField)

//: And voila we now have a border around the UITextView. The beauty of this approach is that with
//: no effort or extra coding, we can re-use the Wrapper - the BorderedView to wrap ANY other view.
//: So here we create an ordinary red view, and then wrap it in the BorderView. 
//: This is a very simple example of Decorator and similar to the example in the GoF book. In the next playground, called Payments we use a more complicated and somewhat more useful example of how to use
//: a wrapper to compose behavior.

let wrappedView = UIView(frame: CGRect(x:0,y:0,width:100,height:100))
wrappedView.backgroundColor = UIColor.red
let anotherBorderedView = BorderedView(frame: CGRect(x:0,y:0,width:100,height:100))
anotherBorderedView.wrap(view: wrappedView)
