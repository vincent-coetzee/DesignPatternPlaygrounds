//: Playground - noun: a place where people can play

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

let wrappedField = UITextField(frame: CGRect(x:0,y:0,width:100,height:30))
wrappedField.text = "hello"
let borderedView = BorderedView(frame: CGRect(x:0,y:0,width:100,height:30))
borderedView.wrap(view:wrappedField)

let wrappedView = UIView(frame: CGRect(x:0,y:0,width:100,height:100))
wrappedView.backgroundColor = UIColor.red
let anotherBorderedView = BorderedView(frame: CGRect(x:0,y:0,width:100,height:100))
anotherBorderedView.wrap(view: wrappedView)
