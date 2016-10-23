//
//  ImageCaptionCropView.swift
//  zanadu
//
//  Created by Benjamin Lefebvre on 5/5/15.
//  Copyright (c) 2015 zanadu. All rights reserved.
//

import Foundation

/**
*  Subclass of ImageCropView with a bottom right button that display/hide a textfield on click
*/
public class ImageCaptionCropView: ImageCropView {
    
    let buttonWidth: CGFloat = 36
    let padding: CGFloat = 10
    
    var caption: String = ""
    var editing = false
    
    var container: UIView!
    var button: UIButton!
    var field: UITextField!
    
    var editIcon: UIImage!
    var validateIcon: UIImage!
    
    public var containerBackgroundColor = UIColor.blackColor() {
        didSet {
            container.backgroundColor = containerBackgroundColor
        }
    }
    public var fieldTintColor = UIColor.whiteColor() {
        didSet {
            field.tintColor = fieldTintColor
        }
    }
    
    public func fieldText() -> String? {
        return field.text
    }
    
    public func isEditing() -> Bool {
        return editing
    }
    
    
    func onImageTapped(sender: AnyObject?) {
        
    }
    
    
    /**
    Setup the cropview and the button, field & container
    
    - parameter image:        the image to crop
    - parameter editIcon:     the caption edit button icon
    - parameter validateIcon: the validate input button icon
    */
    public func setup(image: UIImage, tapDelegate: ImageCropViewTapProtocol? = nil, editIcon: UIImage, validateIcon: UIImage) {
        // init
        super.setup(image, tapDelegate: tapDelegate)
        self.editIcon = editIcon
        self.validateIcon = validateIcon
        
        
        // setup container
        container = UIView(frame: closeFieldFrame())
        container.backgroundColor = containerBackgroundColor
        container.layer.cornerRadius = buttonWidth / 2
        
        
        // setup button
        button = UIButton(frame: CGRectMake(0, 0, buttonWidth, buttonWidth))
        button.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        button.setImage(editIcon, forState: UIControlState.Normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.addTarget(self, action: "onButtonPressed:", forControlEvents: .TouchUpInside)
        
        //setup field
        field = UITextField(frame: CGRectMake(padding * 2, 0, 0, buttonWidth))
        field.textColor = UIColor.whiteColor()
        field.tintColor = fieldTintColor
        field.keyboardAppearance = UIKeyboardAppearance.Dark
        field.delegate = self
        container.addSubview(field)
        container.addSubview(button)
        self.addSubview(container)        
    }
    
    override public func enableEditing() {
        super.enableEditing()
        container.hidden = false
    }
    
    override public func disableEditing() {
        super.disableEditing()
        container.hidden = true
    }
    
    
    func onButtonPressed(sender: UIButton!) {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            if self.editing {
                self.container.frame = self.closeFieldFrame()
                self.field.frame.size.width = 0
                self.button.frame.origin.x = 0
                self.button.setImage(self.editIcon, forState: .Normal)
            } else {
                self.container.frame = self.openFieldFrame()
                self.field.frame.size.width = self.frame.width - self.padding * 5 - self.buttonWidth
                self.button.frame.origin.x = self.field.frame.origin.x + self.field.frame.size.width + self.padding
                self.button.setImage(self.validateIcon, forState: .Normal)
            }
            self.layoutIfNeeded()
        }) { (complete) -> Void in
            print("animation finished", terminator: "")
            self.editing = !self.editing
            if self.editing {
                self.field.becomeFirstResponder()
                self.scrollEnabled = false
            } else {
                self.field.resignFirstResponder()
                self.scrollEnabled = true
            }
        }
    }
    
    private func closeFieldFrame() -> CGRect {
        return CGRectMake(frame.width - buttonWidth - padding + contentOffset.x, frame.height - buttonWidth - padding + contentOffset.y, buttonWidth, buttonWidth)
    }
    
    private func openFieldFrame() -> CGRect {
        return CGRectMake(self.padding, self.container.frame.origin.y, self.frame.width - self.padding * 2, self.container.frame.height)
    }

    
    //MARK: - UIScrollViewDelegate

    public func scrollViewDidScroll(scrollView: UIScrollView) {
        container.frame = self.editing ? self.openFieldFrame() : self.closeFieldFrame()
    }
}

extension ImageCaptionCropView : UITextFieldDelegate {
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.onButtonPressed(nil)
        return false
    }
}