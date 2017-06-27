import UIKit
class CustomTextField: UITextField {
    
    @IBInspectable var leftSideImage:UIImage {
        get {
            return UIImage()
        } set {
            let left: UIImageView = UIImageView(frame: CGRect(x: 2.0, y: 0, width: 35, height: self.bounds.height-2))
            
            // left.backgroundColor = UIColor.gray
            left.image = newValue
            left.contentMode = UIViewContentMode.scaleAspectFit
            
            leftViewMode = .always
            self.leftView = left
            
           // print("image width = \(self.frame.size.width)")
        }
    }
    
    @IBInspectable var rightSideImage:UIImage {
        get {
            return UIImage()
        } set {
            let right: UIImageView = UIImageView(frame: CGRect(x: 0.0, y: 2.0, width: 35, height: self.bounds.height-2))
            
            // left.backgroundColor = UIColor.gray
            right.image = newValue
            right.contentMode = UIViewContentMode.scaleAspectFit
            
            rightViewMode = .always
            self.rightView = right
            
            //print("image width = \(self.frame.size.width)")
        }
    }

   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = newValue > 0
        }
    }
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var leftBorder: CGFloat {
        get {
            return 0.0
        }
        set {
            let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: newValue, height: self.bounds.height))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = self.borderColor
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line(==lineWidth)]", options: [], metrics: metrics, views: views))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line]|", options: [], metrics: nil, views: views))
        }
    }
    
    @IBInspectable var topBorder: CGFloat {
        get {
            return 0.0
        }
        set {
            let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: newValue))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = self.borderColor
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line]|", options: [], metrics: nil, views: views))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line(==lineWidth)]", options: [], metrics: metrics, views: views))
        }
    }
    @IBInspectable var rightBorder: CGFloat {
        get {
            return 0.0
        }
        set {
            let line = UIView(frame: CGRect(x: self.bounds.width, y: 0.0, width: newValue, height: self.bounds.height))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = self.borderColor
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[line(==lineWidth)]|", options: [], metrics: metrics, views: views))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line]|", options: [], metrics: nil, views: views))
        }
    }
    @IBInspectable var bottomBorder: CGFloat {
        get {
            return 0.0
        }
        set {
            let line = UIView(frame: CGRect(x: 0.0, y: self.bounds.height, width: self.bounds.width, height: newValue))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = self.borderColor
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line]|", options: [], metrics: nil, views: views))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[line(==lineWidth)]|", options: [], metrics: metrics, views: views))
        }
    }
    
    
}
