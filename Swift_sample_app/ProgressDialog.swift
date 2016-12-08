//
//  ProgressDialog.swift
//  Progress Dialog
//
//  Created by fukoapps on 30.04.2015.
//  Copyright (c) 2015 FukoApps.com. All rights reserved.
//
import UIKit
import QuartzCore

class ProgressDialog {
    fileprivate var diaColor:UIColor;
    fileprivate var diaSize:Size;
    fileprivate var bg_Color:UIColor;
    fileprivate var bgOpacity:Float
    fileprivate var delegate: UIViewController!
    fileprivate var borderColor:UIColor!
    fileprivate var borderWidth:Float!
    fileprivate var borderRadius:Float!
    fileprivate var fill_bg:UIView!
    internal var isShow: Bool!
    //Get Properties
    internal func GetDialogColor() -> UIColor {
        return diaColor;
    }
    internal func GetDialogBackground() -> UIColor {
        return bg_Color;
    }
    internal func GetDialogSize() -> Size {
        return diaSize;
    }
    internal func GetOpacity() -> Float {
        return bgOpacity;
    }
    internal func GetBorderColor() -> UIColor {
        return borderColor;
    }
    internal func GetBorderWidth() -> Float {
        return borderWidth;
    }
    internal func GetBorderRadius() -> Float {
        return borderRadius;
    }
    //Set Properties
    internal func SetDialogColor(_ color: UIColor) {
        self.diaColor = color
    }
    internal func SetDialogBackground(_ color: UIColor) {
        self.bg_Color = color
    }
    internal func SetDialogSize(_ size: Size) {
        self.diaSize = size
    }
    internal func SetOpacity(_ opacity: Float) {
        self.bgOpacity = opacity
    }
    internal func SetBorderColor(_ color: UIColor) {
        self.borderColor = color
    }
    internal func SetBorderWidth(_ width: Float) {
        self.borderWidth = width
    }
    internal func SetBorderRadius(_ radius: Float)  {
        self.borderRadius = radius
    }
    
    init(delegate:UIViewController) {
        diaColor = UIColor.white
        diaSize = Size(width: 120, height: 120)
        bg_Color = UIColor.black
        bgOpacity = 0.85;
        borderColor = UIColor.gray
        borderWidth = 2.5
        borderRadius = 8.0;
        isShow = false;
        self.delegate = delegate
    }
    internal func Show(_ animate:Bool, mesaj: String) {
        let sc_size = UIScreen.main.bounds;
        
        let fill_rect = CGRect(x: 0, y: 0, width: sc_size.width, height: sc_size.height);
        let bg_rect: CGRect!
        if(mesaj == "") {
            bg_rect = CGRect(x: 0, y: 0, width: diaSize.Width, height: diaSize.Height);
        } else {
            bg_rect = CGRect(x: 0, y: 0, width: diaSize.Width + 22, height: diaSize.Height + 12);
        }
        fill_bg = UIView(frame: fill_rect)
        fill_bg.backgroundColor = UIColor.clear
        let bg = UIView(frame: bg_rect);
        bg.center = CGPoint(x: fill_bg.frame.width / 2 , y: fill_bg.frame.height / 2)
        bg.backgroundColor = self.bg_Color;
        bg.alpha = CGFloat(self.bgOpacity)
        bg.layer.borderColor = self.borderColor.cgColor
        bg.layer.borderWidth = CGFloat(self.borderWidth)
        bg.layer.cornerRadius = CGFloat(self.borderRadius)
        fill_bg.addSubview(bg);
        
        
        
        let progress = UIActivityIndicatorView();
        progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge;
        progress.center = CGPoint(x: fill_bg.frame.size.width / 2, y: fill_bg.frame.size.height / 2)
        progress.startAnimating()
        progress.backgroundColor = diaColor;
        fill_bg.addSubview(progress)
        
        let label = UILabel()
        label.center = CGPoint(x: fill_bg.frame.size.width / 2, y: (fill_bg.frame.size.height / 2) + 5)
        label.frame = CGRect(x: 4, y: bg.frame.height - 30, width: bg.frame.width - 4, height: 30)
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = mesaj
        label.textColor = UIColor.white
        bg.addSubview(label)
        if animate {
            fill_bg.alpha = 0;
        }
        delegate.view.addSubview(fill_bg)
        if animate {
            UIView.animate(withDuration: 1.5, animations: { () -> Void in
                self.fill_bg.alpha = 1.0
                self.isShow = true;
            })
        }
    }
    
    internal func Close() {
        self.fill_bg.removeFromSuperview()
    }
}

class Size {
    internal var Width:CGFloat!
    internal var Height:CGFloat!
    init(width:CGFloat, height:CGFloat) {
        Width = width;
        Height = height
    }
}
