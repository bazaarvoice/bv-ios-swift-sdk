//
//  BVSwiftDemoActionController.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 23/07/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation
import XLActionController

open class BVSwiftDemoActionCell: UICollectionViewCell {
  
  @IBOutlet weak var actionTitleLabel: UILabel!
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  open override func awakeFromNib() {
    super.awakeFromNib()
    initialize()
  }
  
  func initialize() {
    backgroundColor = UIColor.clear
    actionTitleLabel?.textColor = UIColor.darkGray
    let backgroundView = UIView()
    backgroundView.backgroundColor = backgroundColor
    selectedBackgroundView = backgroundView
  }
}

public struct BVSwiftDemoHeaderData {
  
  var title: String
  var subtitle: String
  var image: UIImage
  
  public init(title: String, subtitle: String, image: UIImage) {
    self.title = title
    self.subtitle = subtitle
    self.image = image
  }
}


open class BVSwiftDemoActionController: ActionController<BVSwiftDemoActionCell, String, UICollectionReusableView, Void, UICollectionReusableView, Void> {
  
  private var contextView: ContextView!
  private var normalAnimationRect: UIView!
  private var springAnimationRect: UIView!
  
  let topSpace = CGFloat(40)
  
  public override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    cellSpec = .nibFile(nibName: "BVSwiftDemoActionCell", bundle: Bundle(for: BVSwiftDemoActionCell.self), height: { _ in 60 })
    settings.animation.scale = nil
    settings.animation.present.duration = 0.5
    settings.animation.present.options = UIView.AnimationOptions.curveEaseOut.union(.allowUserInteraction)
    settings.animation.present.springVelocity = 0.0
    settings.animation.present.damping = 0.7
    settings.statusBar.style = .default
    
    onConfigureCellForAction = { cell, action, indexPath in
      cell.actionTitleLabel.text = action.data
        print(action.data ?? "Coool")
      cell.actionTitleLabel.textColor = UIColor.white
      cell.alpha = action.enabled ? 1.0 : 0.5
    }
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    contextView = ContextView(frame: CGRect(x: 0, y: -topSpace, width: collectionView.bounds.width, height: contentHeight + topSpace + 20))
    contextView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth.union(.flexibleBottomMargin)
    collectionView.clipsToBounds = false
    collectionView.addSubview(contextView)
    collectionView.sendSubviewToBack(contextView)
    
    
    normalAnimationRect = UIView(frame: CGRect(x: 0, y: view.bounds.height/2, width: 30, height: 30))
    normalAnimationRect.isHidden = true
    view.addSubview(normalAnimationRect)
    
    springAnimationRect = UIView(frame: CGRect(x: 40, y: view.bounds.height/2, width: 30, height: 30))
    springAnimationRect.isHidden = true
    view.addSubview(springAnimationRect)
    
    backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.65)
  }
  
  override open func onWillPresentView() {
    super.onWillPresentView()
    
    collectionView.frame.origin.y = contentHeight + (topSpace - contextView.topSpace)
    
    startAnimation()
    let initSpace = CGFloat(45.0)
    let initTime = 0.1
    let animationDuration = settings.animation.present.duration - 0.1
    
    let options = UIView.AnimationOptions.curveEaseOut.union(.allowUserInteraction)
    UIView.animate(withDuration: initTime, delay: settings.animation.present.delay, options: options, animations: { [weak self] in
      guard let me = self else {
        return
      }
      
      var frame = me.springAnimationRect.frame
      frame.origin.y = frame.origin.y - initSpace
      me.springAnimationRect.frame = frame
      }, completion: { [weak self] finished in
        guard let me = self , finished else {
          self?.finishAnimation()
          return
        }
        
        UIView.animate(withDuration: animationDuration - initTime, delay: 0, options: options, animations: { [weak self] in
          guard let me = self else {
            return
          }
          
          var frame = me.springAnimationRect.frame
          frame.origin.y -= (me.contentHeight - initSpace)
          me.springAnimationRect.frame = frame
          }, completion: { (finish) -> Void in
            me.finishAnimation()
        })
    })
    
    
    UIView.animate(withDuration: animationDuration - initTime, delay: settings.animation.present.delay + initTime, options: options, animations: { [weak self] in
      guard let me = self else {
        return
      }
      
      var frame = me.normalAnimationRect.frame
      frame.origin.y -= me.contentHeight
      me.normalAnimationRect.frame = frame
      }, completion:nil)
  }
  
  
  override open func dismissView(_ presentedView: UIView, presentingView: UIView, animationDuration: Double, completion: ((_ completed: Bool) -> Void)?) {
    finishAnimation()
    finishAnimation()
    
    let animationSettings = settings.animation.dismiss
    UIView.animate(withDuration: animationDuration,
                   delay: animationSettings.delay,
                   usingSpringWithDamping: animationSettings.damping,
                   initialSpringVelocity: animationSettings.springVelocity,
                   options: animationSettings.options,
                   animations: { [weak self] in
                    self?.backgroundView.alpha = 0.0
      },
                   completion:nil)
    
    gravityBehavior.action = { [weak self] in
      if let me = self {
        let progress = min(1.0, me.collectionView.frame.origin.y / (me.contentHeight + (me.topSpace - me.contextView.topSpace)))
        let pixels = min(20, progress * 150.0)
        me.contextView.diff = -pixels
        me.contextView.setNeedsDisplay()
        
        if (self?.collectionView.frame.origin.y)! > (self?.view.bounds.size.height)! {
          self?.animator.removeAllBehaviors()
          completion?(true)
        }
      }
    }
    animator.addBehavior(gravityBehavior)
  }
  
  //MARK : Private Helpers
  
  private var diff = CGFloat(0)
  private var displayLink: CADisplayLink!
  private var animationCount = 0
  
  private lazy var animator: UIDynamicAnimator = { [unowned self] in
    let animator = UIDynamicAnimator(referenceView: self.view)
    return animator
    }()
  
  private lazy var gravityBehavior: UIGravityBehavior = { [unowned self] in
    let gravityBehavior = UIGravityBehavior(items: [self.collectionView])
    gravityBehavior.magnitude = 2.0
    return gravityBehavior
    }()
  
  
  @objc private func update(_ displayLink: CADisplayLink) {
    
    let normalRectLayer = normalAnimationRect.layer.presentation()
    let springRectLayer = springAnimationRect.layer.presentation()
    
    let normalRectFrame = (normalRectLayer!.value(forKey: "frame")! as AnyObject).cgRectValue
    let springRectFrame = (springRectLayer!.value(forKey: "frame")! as AnyObject).cgRectValue
    contextView.diff = (normalRectFrame?.origin.y)! - (springRectFrame?.origin.y)!
    contextView.setNeedsDisplay()
  }
  
  private func startAnimation() {
    if displayLink == nil {
      self.displayLink = CADisplayLink(target: self, selector: #selector(BVSwiftDemoActionController.update(_:)))
        self.displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
    }
    animationCount += 1
  }
  
  private func finishAnimation() {
    animationCount -= 1
    if animationCount == 0 {
      displayLink.invalidate()
      displayLink = nil
    }
  }
  
  
  private class ContextView: UIView {
    let topSpace = CGFloat(25)
    var diff = CGFloat(0)
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
      let path = UIBezierPath()
      
      path.move(to: CGPoint(x: 0, y: frame.height))
      path.addLine(to: CGPoint(x: frame.width, y: frame.height))
      path.addLine(to: CGPoint(x: frame.width, y: topSpace))
      path.addQuadCurve(to: CGPoint(x: 0, y: topSpace), controlPoint: CGPoint(x: frame.width/2, y: topSpace - diff))
      path.close()
      
      if let context = UIGraphicsGetCurrentContext(){
        context.addPath(path.cgPath)
        UIColor.bazaarvoiceNavy.set()
        context.fillPath()
      }
    }
  }
  
}
