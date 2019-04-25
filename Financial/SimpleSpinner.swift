import Foundation
import UIKit

public class SimpleSpinner {
    
    var isEnable:Bool
    var insideOfView:UIView
    var spinnerDefaultItemPosition:Int
    var spinnerLeftPadding:CGFloat
    var spinnerRightPadding:CGFloat
    var leftGapView:UIView
    var rightGapView:UIView
    var spinnerTextFont:UIFont
    var spinnerTextColor:UIColor
    var spinnerTextAlignment:NSTextAlignment
    var spinnerDropTextColor:UIColor
    var spinnerDropBackgroundColor:UIColor
    var spinnerDropTextAlignment:UIControl.ContentHorizontalAlignment
    var spinnerItemPaddingTop:CGFloat
    var spinnerItemPaddingBottom:CGFloat
    var spinnerScrollView:UIScrollView?
    var spinnerCancelBtn:UIButton?
    var spinnerSourceView:UIView?
    var spinnerLabel:UILabel?
    var spinnerTitleStringArray:[String]
    var spinnerCallback:((_ position:Int) -> Void)?
    
    
    init() {
        isEnable = false
        insideOfView = UIView()
        spinnerDefaultItemPosition = -1
        spinnerLeftPadding = 10
        spinnerRightPadding = 30
        leftGapView = UIView()
        rightGapView = UIView()
        spinnerTextFont = UIFont.systemFont(ofSize: 15.0)
        spinnerTextColor = UIColor.darkGray
        spinnerTextAlignment = .left
        spinnerDropTextColor = UIColor.white
        spinnerDropBackgroundColor = UIColor.lightGray
        spinnerDropTextAlignment = .left
        spinnerItemPaddingTop = 15
        spinnerItemPaddingBottom = 15
        spinnerScrollView = nil
        spinnerCancelBtn = nil
        spinnerSourceView = nil
        spinnerLabel = nil
        spinnerTitleStringArray = [String]()
        spinnerCallback = nil
    }
    
    func createSpinner(abbs:String?, insideOfView:UIView, titleArray:[String], textAlignment:NSTextAlignment, dropTextAlignment:UIControl.ContentHorizontalAlignment, callback:@escaping (_ position:Int) -> Void) {
        DispatchQueue.main.async {
            
            self.insideOfView = insideOfView
            self.spinnerTitleStringArray = titleArray
            self.spinnerTextAlignment = textAlignment
            self.spinnerDropTextAlignment = dropTextAlignment
            self.spinnerCallback = callback
            
            self.spinnerSourceView = UIView()
            self.spinnerSourceView!.translatesAutoresizingMaskIntoConstraints = false
            insideOfView.addSubview(self.spinnerSourceView!)
            let topCons = NSLayoutConstraint(item: self.spinnerSourceView!, attribute: .top, relatedBy: .equal, toItem: insideOfView, attribute: .top, multiplier: 1.0, constant: 0)
            let bottomCons = NSLayoutConstraint(item: self.spinnerSourceView!, attribute: .bottom, relatedBy: .equal, toItem: insideOfView, attribute: .bottom, multiplier: 1.0, constant: 0)
            let leadCons = NSLayoutConstraint(item: self.spinnerSourceView!, attribute: .leading, relatedBy: .equal, toItem: insideOfView, attribute: .leading, multiplier: 1.0, constant: 0)
            let trailCons = NSLayoutConstraint(item: self.spinnerSourceView!, attribute: .trailing, relatedBy: .equal, toItem: insideOfView, attribute: .trailing, multiplier: 1.0, constant: 0)
            insideOfView.addConstraints([topCons,bottomCons,leadCons,trailCons])
            
            self.leftGapView.translatesAutoresizingMaskIntoConstraints = false
            self.spinnerSourceView!.addSubview(self.leftGapView)
            let topConsLeftGap = NSLayoutConstraint(item: self.leftGapView, attribute: .top, relatedBy: .equal, toItem: self.spinnerSourceView!, attribute: .top, multiplier: 1.0, constant: 0)
            let bottomConsLeftGap = NSLayoutConstraint(item: self.leftGapView, attribute: .bottom, relatedBy: .equal, toItem: self.spinnerSourceView!, attribute: .bottom, multiplier: 1.0, constant: 0)
            let leadConsLeftGap = NSLayoutConstraint(item: self.leftGapView, attribute: .leading, relatedBy: .equal, toItem: self.spinnerSourceView!, attribute: .leading, multiplier: 1.0, constant: 0)
            let widthConsLeftGap = NSLayoutConstraint(item: self.leftGapView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.spinnerLeftPadding)
            self.spinnerSourceView!.addConstraints([topConsLeftGap,bottomConsLeftGap,leadConsLeftGap,widthConsLeftGap])
            
            self.rightGapView.translatesAutoresizingMaskIntoConstraints = false
            self.spinnerSourceView!.addSubview(self.rightGapView)
            let topConsRightGap = NSLayoutConstraint(item: self.rightGapView, attribute: .top, relatedBy: .equal, toItem: self.spinnerSourceView!, attribute: .top, multiplier: 1.0, constant: 0)
            let bottomConsRightGap = NSLayoutConstraint(item: self.rightGapView, attribute: .bottom, relatedBy: .equal, toItem: self.spinnerSourceView!, attribute: .bottom, multiplier: 1.0, constant: 0)
            let trailConsRightGap = NSLayoutConstraint(item: self.rightGapView, attribute: .trailing, relatedBy: .equal, toItem: self.spinnerSourceView!, attribute: .trailing, multiplier: 1.0, constant: 0)
            let widthConsRightGap = NSLayoutConstraint(item: self.rightGapView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.spinnerRightPadding)
            self.spinnerSourceView!.addConstraints([topConsRightGap,bottomConsRightGap,trailConsRightGap,widthConsRightGap])
            
            self.spinnerLabel = UILabel()
            self.spinnerLabel!.translatesAutoresizingMaskIntoConstraints = false
            self.spinnerLabel!.textAlignment = self.spinnerTextAlignment
            self.spinnerLabel!.font = self.spinnerTextFont
            self.spinnerLabel!.textColor = self.spinnerTextColor
            if (self.spinnerTitleStringArray.count > 0) {
                if (self.spinnerTitleStringArray.count > self.spinnerDefaultItemPosition && self.spinnerDefaultItemPosition >= 0) {
                    self.spinnerLabel!.text = self.spinnerTitleStringArray[self.spinnerDefaultItemPosition]
                } else {
                    self.spinnerLabel!.text = self.spinnerTitleStringArray[0]
                    self.spinnerDefaultItemPosition = 0
                }
            } else {
                self.spinnerLabel!.text = ""
                self.spinnerDefaultItemPosition = -1
            }
            self.spinnerSourceView!.addSubview(self.spinnerLabel!)
            
            let heightConsLabel = NSLayoutConstraint(item: self.spinnerLabel!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20)
            heightConsLabel.priority = UILayoutPriority(rawValue: 249)
            let widthConsLabel = NSLayoutConstraint(item: self.spinnerLabel!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20)
            widthConsLabel.priority = UILayoutPriority(rawValue: 249)
            self.spinnerLabel!.addConstraints([heightConsLabel,widthConsLabel])
            
            let centerYConsLabel = NSLayoutConstraint(item: self.spinnerLabel!, attribute: .centerY, relatedBy: .equal, toItem: self.spinnerSourceView!, attribute: .centerY, multiplier: 1.0, constant: 0)
            let leadConsLabel = NSLayoutConstraint(item: self.spinnerLabel!, attribute: .leading, relatedBy: .equal, toItem: self.leftGapView, attribute: .trailing, multiplier: 1.0, constant: 0)
            let trailConsLabel = NSLayoutConstraint(item: self.spinnerLabel!, attribute: .trailing, relatedBy: .equal, toItem: self.rightGapView, attribute: .leading, multiplier: 1.0, constant: 0)
            let heightConsLabelView = NSLayoutConstraint(item: self.spinnerLabel!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 21.0)
            heightConsLabelView.priority = UILayoutPriority(rawValue: 249)
            self.spinnerSourceView!.addConstraints([centerYConsLabel,leadConsLabel,trailConsLabel,heightConsLabelView])
            
            let spinnerBtn = UIButton()
            spinnerBtn.translatesAutoresizingMaskIntoConstraints = false
            self.spinnerSourceView!.addSubview(spinnerBtn)
            let topConsBtn = NSLayoutConstraint(item: spinnerBtn, attribute: .top, relatedBy: .equal, toItem: self.spinnerSourceView!, attribute: .top, multiplier: 1.0, constant: 0)
            let bottomConsBtn = NSLayoutConstraint(item: spinnerBtn, attribute: .bottom, relatedBy: .equal, toItem: self.spinnerSourceView!, attribute: .bottom, multiplier: 1.0, constant: 0)
            let leadConsBtn = NSLayoutConstraint(item: spinnerBtn, attribute: .leading, relatedBy: .equal, toItem: self.spinnerSourceView!, attribute: .leading, multiplier: 1.0, constant: 0)
            let trailConsBtn = NSLayoutConstraint(item: spinnerBtn, attribute: .trailing, relatedBy: .equal, toItem: self.spinnerSourceView!, attribute: .trailing, multiplier: 1.0, constant: 0)
            self.spinnerSourceView!.addConstraints([topConsBtn,bottomConsBtn,leadConsBtn,trailConsBtn])
            
            spinnerBtn.addTargetClosure{ _ in
                
                if (self.isEnable) {
                    if (self.spinnerTitleStringArray.count > 0) {
                        self.isEnable = false
                        self.spinnerScrollViewDisplay(abbs: nil, spinnerView: self.spinnerSourceView!)
                    }
                }
                
            }
            if (self.spinnerDefaultItemPosition >= 0) {
                if (self.spinnerCallback != nil) {
                    self.spinnerCallback!(self.spinnerDefaultItemPosition)
                }
            }
            
            self.isEnable = true
            
        }
        
        
    }
    
    func removeSpinner(abbs:String?) {
        if (spinnerSourceView != nil) {
            spinnerSourceView?.removeFromSuperview()
        }
    }
    
    func spinnerScrollViewDisplay(abbs:String?, spinnerView:UIView) {
        
        let absFrame = getAbsoluteFame(abbs: nil, sourceView: spinnerView)
        let outermostView = getOutermostView(abbs: nil, sourceView: spinnerView)
        
        let upSpace = absFrame.origin.y
        let downSpace = UIScreen.main.bounds.size.height - absFrame.origin.y - absFrame.size.height
        
        var useUp:Bool = false
        if (upSpace > downSpace) {
            useUp = true
        }
        
        var maxWidth:CGFloat = 0
        var maxHeight:CGFloat = 0
        for i in 1..<spinnerTitleStringArray.count {
            let cSize = NSString(string: spinnerTitleStringArray[i-1]).size(withAttributes: [NSAttributedString.Key.font : spinnerTextFont])
            let cWidth = cSize.width
            let cHeight = cSize.height
            if (cWidth > maxWidth) {
                maxWidth = cWidth
            }
            if (cHeight > maxHeight) {
                maxHeight = cHeight
            }
        }
        
        if (absFrame.size.width > (maxWidth + self.leftGapView.frame.size.width + self.rightGapView.frame.size.width)) {
            maxWidth = absFrame.size.width - self.leftGapView.frame.size.width - self.rightGapView.frame.size.width
        }
        
        var displayItemCount:Int = 0
        if (useUp) {
            displayItemCount = Int(upSpace / (maxHeight+spinnerItemPaddingTop+spinnerItemPaddingBottom)) - 1
        } else {
            displayItemCount = Int(downSpace / (maxHeight+spinnerItemPaddingTop+spinnerItemPaddingBottom)) - 1
        }
        if (spinnerTitleStringArray.count < displayItemCount) {
            displayItemCount = spinnerTitleStringArray.count
        }
        
        spinnerCancelBtn = UIButton()
        spinnerCancelBtn!.translatesAutoresizingMaskIntoConstraints = false
        outermostView!.addSubview(spinnerCancelBtn!)
        let topConsCancel = NSLayoutConstraint(item: spinnerCancelBtn!, attribute: .top, relatedBy: .equal, toItem: outermostView!, attribute: .top, multiplier: 1.0, constant: 0)
        let bottomConsCancel = NSLayoutConstraint(item: spinnerCancelBtn!, attribute: .bottom, relatedBy: .equal, toItem: outermostView!, attribute: .bottom, multiplier: 1.0, constant: 0)
        let leadConsCancel = NSLayoutConstraint(item: spinnerCancelBtn!, attribute: .leading, relatedBy: .equal, toItem: outermostView!, attribute: .leading, multiplier: 1.0, constant: 0)
        let trailConsCancel = NSLayoutConstraint(item: spinnerCancelBtn!, attribute: .trailing, relatedBy: .equal, toItem: outermostView!, attribute: .trailing, multiplier: 1.0, constant: 0)
        outermostView!.addConstraints([topConsCancel,bottomConsCancel,leadConsCancel,trailConsCancel])
        spinnerCancelBtn?.addTargetClosure(closure: { (sender) in
            self.spinnerScrollViewCancel(abbs: nil)
        })
        
        spinnerScrollView = UIScrollView()
        outermostView!.addSubview(spinnerScrollView!)
        if (useUp) {
            spinnerScrollView!.frame = CGRect(x: absFrame.origin.x, y: absFrame.origin.y - (maxHeight + spinnerItemPaddingTop + spinnerItemPaddingBottom) * CGFloat(displayItemCount), width: (maxWidth + self.leftGapView.frame.size.width + self.rightGapView.frame.size.width), height: (maxHeight + spinnerItemPaddingTop + spinnerItemPaddingBottom) * CGFloat(displayItemCount))
        } else {
            spinnerScrollView!.frame = CGRect(x: absFrame.origin.x, y: absFrame.origin.y + absFrame.size.height, width: (maxWidth + self.leftGapView.frame.size.width + self.rightGapView.frame.size.width), height: (maxHeight + spinnerItemPaddingTop + spinnerItemPaddingBottom) * CGFloat(displayItemCount))
        }
        spinnerScrollView!.contentSize = CGSize(width: (maxWidth + self.leftGapView.frame.size.width + self.rightGapView.frame.size.width), height: (maxHeight + spinnerItemPaddingTop + spinnerItemPaddingBottom) * CGFloat(spinnerTitleStringArray.count))
        
        
        let scrollContentView = UIView()
        spinnerScrollView!.addSubview(scrollContentView)
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        let topCons = NSLayoutConstraint(item: scrollContentView, attribute: .top, relatedBy: .equal, toItem: spinnerScrollView!, attribute: .top, multiplier: 1.0, constant: 0)
        let centerCons = NSLayoutConstraint(item: scrollContentView, attribute: .centerX, relatedBy: .equal, toItem: spinnerScrollView!, attribute: .centerX, multiplier: 1.0, constant: 0)
        let widthCons = NSLayoutConstraint(item: scrollContentView, attribute: .width, relatedBy: .equal, toItem: spinnerScrollView!, attribute: .width, multiplier: 1.0, constant: 0)
        let heightCons = NSLayoutConstraint(item: scrollContentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: (maxHeight + spinnerItemPaddingTop + spinnerItemPaddingBottom) * CGFloat(spinnerTitleStringArray.count))
        heightCons.priority = UILayoutPriority(rawValue: 248)
        spinnerScrollView!.addConstraints([topCons,centerCons,widthCons])
        scrollContentView.addConstraints([heightCons])
        
        let itemBtn = UIButton()
        itemBtn.tag = 0
        itemBtn.addTargetClosure{ _ in
            
            self.spinnerScrollBtnClick(position: 0)
            
        }
        itemBtn.translatesAutoresizingMaskIntoConstraints = false
        itemBtn.backgroundColor = UIColor.lightGray
        itemBtn.titleLabel?.font = spinnerTextFont
        itemBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: spinnerLeftPadding, bottom: 0, right: spinnerRightPadding)
        itemBtn.contentHorizontalAlignment = spinnerDropTextAlignment
        itemBtn.setTitle(spinnerTitleStringArray[0], for: UIControl.State.normal)
        let btnHeightCons = NSLayoutConstraint(item: itemBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: (maxHeight + spinnerItemPaddingTop + spinnerItemPaddingBottom))
        itemBtn.addConstraints([btnHeightCons])
        scrollContentView.addSubview(itemBtn)
        let btnLeftCons = NSLayoutConstraint(item: itemBtn, attribute: .leading, relatedBy: .equal, toItem: scrollContentView, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let btnRightCons = NSLayoutConstraint(item: itemBtn, attribute: .trailing, relatedBy: .equal, toItem: scrollContentView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let btnTopCons = NSLayoutConstraint(item: itemBtn, attribute: .top, relatedBy: .equal, toItem: scrollContentView, attribute: .top, multiplier: 1.0, constant: 0.0)
        scrollContentView.addConstraints([btnLeftCons,btnRightCons,btnTopCons])
        var currentItemBtn = itemBtn
        
        if (spinnerTitleStringArray.count > 1) {
            for j in 2...spinnerTitleStringArray.count {
                
                let itemBtn2 = UIButton()
                itemBtn2.addTargetClosure{ _ in
                    
                    self.spinnerScrollBtnClick(position: j-1)
                    
                }
                itemBtn2.tag = j-1
                itemBtn2.translatesAutoresizingMaskIntoConstraints = false
                itemBtn2.backgroundColor = UIColor.lightGray
                itemBtn2.titleLabel?.font = spinnerTextFont
                itemBtn2.titleEdgeInsets = UIEdgeInsets(top: 0, left: spinnerLeftPadding, bottom: 0, right: spinnerRightPadding)
                itemBtn2.contentHorizontalAlignment = spinnerDropTextAlignment
                itemBtn2.setTitle(spinnerTitleStringArray[j-1], for: UIControl.State.normal)
                scrollContentView.addSubview(itemBtn2)
                let btnHeightCons2 = NSLayoutConstraint(item: itemBtn2, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: (maxHeight + spinnerItemPaddingTop + spinnerItemPaddingBottom))
                let btnLeftCons2 = NSLayoutConstraint(item: itemBtn2, attribute: .leading, relatedBy: .equal, toItem: scrollContentView, attribute: .leading, multiplier: 1.0, constant: 0.0)
                let btnRightCons2 = NSLayoutConstraint(item: itemBtn2, attribute: .trailing, relatedBy: .equal, toItem: scrollContentView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
                let btnTopCons2 = NSLayoutConstraint(item: itemBtn2, attribute: .top, relatedBy: .equal, toItem: currentItemBtn, attribute: .bottom, multiplier: 1.0, constant: 0.0)
                scrollContentView.addConstraints([btnLeftCons2,btnRightCons2,btnTopCons2])
                itemBtn2.addConstraints([btnHeightCons2])
                currentItemBtn = itemBtn2
            }
        }
        
        let btnBottomCons = NSLayoutConstraint(item: currentItemBtn, attribute: .bottom, relatedBy: .equal, toItem: scrollContentView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        scrollContentView.addConstraints([btnBottomCons])
        
    }
    
    func spinnerScrollViewCancel(abbs:String?) {
        isEnable = true
        if (spinnerScrollView != nil) {
            spinnerCancelBtn!.removeFromSuperview()
            spinnerScrollView!.removeFromSuperview()
            spinnerCancelBtn = nil
            spinnerScrollView = nil
        }
    }
    
    func spinnerScrollBtnClick(position:Int) {
        setSelection(abbs: nil, position: position) {
            self.spinnerScrollViewCancel(abbs: nil)
        }
    }
    
    func setSelection(abbs:String?, position:Int, completion:(() -> Void)?) {
        
        if (position >= 0) {
            if (position < spinnerTitleStringArray.count) {
                spinnerDefaultItemPosition = position
                spinnerLabel!.text = spinnerTitleStringArray[position]
                if (spinnerCallback != nil) {
                    DispatchQueue.main.async {
                        self.spinnerCallback!(position)
                        if (completion != nil) {
                            completion!()
                        }
                    }
                }
            } else {
                spinnerDefaultItemPosition = 0
                spinnerLabel!.text = spinnerTitleStringArray[0]
                if (spinnerCallback != nil) {
                    DispatchQueue.main.async {
                        self.spinnerCallback!(0)
                        if (completion != nil) {
                            completion!()
                        }
                    }
                }
            }
        } else {
            if (spinnerTitleStringArray.count > 0) {
                spinnerDefaultItemPosition = 0
                spinnerLabel!.text = spinnerTitleStringArray[0]
                if (spinnerCallback != nil) {
                    DispatchQueue.main.async {
                        self.spinnerCallback!(0)
                        if (completion != nil) {
                            completion!()
                        }
                    }
                }
            } else {
                spinnerDefaultItemPosition = -1
                spinnerLabel!.text = ""
                if (spinnerCallback != nil) {
                    DispatchQueue.main.async {
                        self.spinnerCallback!(-1)
                        if (completion != nil) {
                            completion!()
                        }
                    }
                }
            }
        }
    }
    
    func getAbsoluteFame(abbs:String?, sourceView:UIView) -> CGRect {
        
        var originX:CGFloat = 0
        var originY:CGFloat = 0
        
        originX = originX + sourceView.frame.origin.x
        originY = originY + sourceView.frame.origin.y
        
        var superView:UIView? = sourceView.superview
        while (superView != nil) {
            if superView is UIScrollView {
                originY = originY - (superView as! UIScrollView).contentOffset.y
            }
            originX = originX + superView!.frame.origin.x
            originY = originY + superView!.frame.origin.y
            superView = superView!.superview
        }
        return CGRect(x: originX, y: originY, width: sourceView.frame.width, height: sourceView.frame.height)
        
    }
    
    func getOutermostView(abbs:String?, sourceView:UIView) -> UIView? {
        
        var superView:UIView? = sourceView.superview
        while (superView != nil) {
            if (superView!.superview != nil) {
                superView = superView!.superview
            } else {
                return superView
            }
        }
        return superView
        
    }
}
