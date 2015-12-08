//
//  ImageCropView.swift
//  zanadu
//
//  Created by Benjamin Lefebvre on 4/30/15.
//  Copyright (c) 2015 zanadu. All rights reserved.
//

/**
ImageCropView allow you to easily display and crop images

1. Just put an UIScrollView at the size you want using Storyboard
2. In ViewDidLoad function use ImageCropView's setup() function to init the component
3. After the UI is rendered you can call the display() function
4. Let the user zoom & move the image as they want
5. Get the cropped image by using ImageCropView's croppedImage() function
5. Get the cropped image by using ImageCropView's croppedImage() function
6. Tap events can be handled using ImageCropViewTapProtocol
7. You can use this component to display a read only cropped image too


    imageCropView.setup(myImage)
    ...
    imageCropView.display()
    ...
    let croppedImage = imageCropView.croppedImage()
    // or
    let cropRect = imageCropView.cropRect()
    ...
    imageCropView.setCrop(rect)
*/

@IBDesignable
public class ImageCropView: UIScrollView, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    //MARK: - IBInspectable Properties
    
    @IBInspectable var minScale: CGFloat = 0.8
    
    
    //MARK: - Private Properties

    private var tapDelegate: ImageCropViewTapProtocol?

    
    //MARK: - Public Properties

    public var coverImageView: UIImageView!
    public var editable = true {
        didSet {
            if editable {
                enableEditing()
            } else {
                disableEditing()
            }
        }
    }

    
    //MARK: - Initializers

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    //MARK: - Methods
    
    /**
    Setup the view with a given image

    - parameter image: Will be displayed in the view
    */
    public func setup(image: UIImage, tapDelegate: ImageCropViewTapProtocol? = nil) {
        coverImageView = UIImageView(image: image)
        coverImageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size:image.size)

        addSubview(coverImageView)
        contentSize = image.size

        self.delegate = self
        self.tapDelegate = tapDelegate
    }
    
    public func display() {
        let scrollViewFrame = frame
        let scaleWidth = scrollViewFrame.size.width / contentSize.width
        let scaleHeight = scrollViewFrame.size.height / contentSize.height
        let tmpMinScale = max(scaleWidth, scaleHeight)
        
        minimumZoomScale = tmpMinScale
        maximumZoomScale = (tmpMinScale > minScale) ? tmpMinScale : minScale
        zoomScale = tmpMinScale
        
        contentOffset.x = (contentSize.width - bounds.width) / 2
        contentOffset.y = (contentSize.height - bounds.height) / 2
    }

    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let tapDelegate = tapDelegate {
            tapDelegate.onImageCropViewTapped(self)
        }
    }
    
    
    public func enableEditing() {
        scrollEnabled = true
        pinchGestureRecognizer?.enabled = true
    }
    
    
    public func disableEditing() {
        scrollEnabled = false
        pinchGestureRecognizer?.enabled = false
    }
    
    
    /**
    Crop the image using the ImageCropView bounds and scale factor

    - returns: the cropped image
    */
    public func croppedImage() -> UIImage? {
        let tmp = CGImageCreateWithImageInRect(coverImageView.image?.CGImage, cropRect())
        let img = UIImage(CGImage: tmp!, scale: coverImageView.image!.scale, orientation: coverImageView.image!.imageOrientation)
        
        return img
    }

    /**
    Returns the Crop Rect of the image
    
    The cropRect will be used to display the image with the right scale and offset.
    It is calculated using the ImageCropView bounds and scale factor.
    
    - returns: the cropRect
    */
    public func cropRect() -> CGRect {
        let scale = coverImageView.image!.size.width / coverImageView.frame.width
        let cropRect = CGRectMake(contentOffset.x * scale, contentOffset.y * scale, frame.width * scale, frame.height * scale)
        return cropRect
    }
    
    /**
    Apply crop parameters on the image
    
    - parameter rect: The crop Rect
    */
    public func setCrop(rect: CGRect) {
        let scale: CGFloat = rect.width / frame.width
  
        zoomScale = 1 / scale
        contentOffset.x = rect.origin.x / scale
        contentOffset.y = rect.origin.y / scale
    }
    
    //MARK: - UIScrollViewDelegate
    
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return coverImageView
    }
}