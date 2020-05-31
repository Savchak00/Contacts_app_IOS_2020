//
//  DetailTransition.swift
//  Contacts
//
//  Created by Daniel Savchak on 31.05.2020.
//

import UIKit

@objc
protocol ZoomViewController {
    func zoomingImageView(for transition: ZoomTransitionDelegate) -> UIImageView?
    func zoomingIsOnlineView(for transition: ZoomTransitionDelegate) ->UIView?
    func zoomingNameView(for transition: ZoomTransitionDelegate) ->UIView?
    func zoomingEmailView(for transition: ZoomTransitionDelegate) ->UIView?
    func zoomingBackButton(for transition: ZoomTransitionDelegate) ->UIView?
}

enum TransitionState {
    case initial
    case final
}

class ZoomTransitionDelegate : NSObject {
    var transitionDuration = 0.5
    var operation: Bool = true
    
    init(operation:Bool) {
        self.operation = operation
    }
    //true -> showDetail , false -> goBack
    private let backgroundScale = CGFloat(0.7)
    
    typealias ZoomingViews = (otherView: UIView, imageView: UIView)
    
    func configureView(for state: TransitionState, containerView: UIView, backgroundViewController: UIViewController, viewsInBackground:  ZoomingViews, viewsInForeground: ZoomingViews, snaphotView: ZoomingViews)
    {
        switch state {
        case .initial:
            backgroundViewController.view.transform = CGAffineTransform.identity
            backgroundViewController.view.alpha = 1
            
            snaphotView.imageView.frame = containerView.convert(viewsInBackground.imageView.frame, from: viewsInBackground.imageView.superview)
            
            snaphotView.imageView.layer.cornerRadius = snaphotView.imageView.frame.size.width/2
            snaphotView.imageView.clipsToBounds = true
            
        case .final:
            backgroundViewController.view.transform = CGAffineTransform(scaleX: backgroundScale, y: backgroundScale)
            backgroundViewController.view.alpha =  0
            
            snaphotView.imageView.frame = containerView.convert(viewsInForeground.imageView.frame, to: viewsInForeground.imageView.superview)
            snaphotView.imageView.layer.cornerRadius = snaphotView.imageView.frame.size.width/2
            snaphotView.imageView.clipsToBounds = true
        }
    
    }
    
}

extension ZoomTransitionDelegate: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView
        var backgroundViewController = fromVC
        var foregroundViewController = toVC
        if operation == false {
            backgroundViewController = toVC
            foregroundViewController = fromVC
        }
        let maybeBackgroundImageView = (backgroundViewController as? ZoomViewController)?.zoomingImageView(for: self)
        let maybeForegroundImageView = (foregroundViewController as? ZoomViewController)?.zoomingImageView(for: self)
        assert(maybeBackgroundImageView != nil, "Cannot find imageView in backgroundVC")
        assert(maybeForegroundImageView != nil, "Cannot find imageView in backgroundVC")
        
        let backgroundImageView = maybeBackgroundImageView!
        let foregroundImageView = maybeForegroundImageView!
        
        if operation == false {
            let maybeIsOnlineView = (foregroundViewController as? ZoomViewController)?.zoomingIsOnlineView(for: self)
            assert(maybeIsOnlineView != nil, "Cannot find isOnline in backgroundVC")
            
            let isOnlineView = maybeIsOnlineView!
            
            isOnlineView.isHidden = true
            
            let maybeNameView = (foregroundViewController as? ZoomViewController)?.zoomingNameView(for: self)
            assert(maybeNameView != nil, "Cannot find name in backgroundVC")
            
            let nameView = maybeNameView!
            
            nameView.isHidden = true
            
            let maybeEmailView = (foregroundViewController as? ZoomViewController)?.zoomingEmailView(for: self)
            assert(maybeEmailView != nil, "Cannot find email in backgroundVC")
            
            let emailView = maybeEmailView!
            
            emailView.isHidden = true
            
            let maybeBackButtonView = (foregroundViewController as? ZoomViewController)?.zoomingBackButton(for: self)
            assert(maybeBackButtonView != nil, "Cannot find backButton in backgroundVC")
            
            let backButton = maybeBackButtonView!
            
            backButton.isHidden = true
            
        }
        let imageViewSnaphot = UIImageView(image: backgroundImageView.image)
        imageViewSnaphot.contentMode = .scaleAspectFill
        imageViewSnaphot.layer.masksToBounds = true
        
        backgroundImageView.isHidden = true
        foregroundImageView.isHidden = true
        let foregroundViewBackgroundColor = foregroundViewController.view.backgroundColor
        foregroundViewController.view.backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.white
        
        containerView.addSubview(backgroundViewController.view)
        containerView.addSubview(foregroundViewController.view)
        containerView.addSubview(imageViewSnaphot)
        
         
        var preTransitionState = TransitionState.initial
        var postTransitionState = TransitionState.final
        
        if operation == false {
            preTransitionState = TransitionState.final
            postTransitionState = TransitionState.initial
        }
        
        configureView(for: preTransitionState, containerView: containerView, backgroundViewController: backgroundViewController, viewsInBackground: (backgroundImageView, backgroundImageView), viewsInForeground: (foregroundImageView, foregroundImageView), snaphotView: (imageViewSnaphot, imageViewSnaphot))
        
        foregroundViewController.view.layoutIfNeeded()
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
            
            self.configureView(for: postTransitionState, containerView: containerView, backgroundViewController: backgroundViewController, viewsInBackground: (backgroundImageView, backgroundImageView), viewsInForeground: (foregroundImageView, foregroundImageView), snaphotView: (imageViewSnaphot, imageViewSnaphot))
            
        }) { (finished) in
            
            backgroundViewController.view.transform = CGAffineTransform.identity
            imageViewSnaphot.removeFromSuperview()
            backgroundImageView.isHidden = false
            foregroundImageView.isHidden = false
            foregroundViewController.view.backgroundColor = foregroundViewBackgroundColor
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

extension ZoomTransitionDelegate: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed is ZoomViewController{
            self.operation = false
            return self
        }
        return nil
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presenting is ZoomViewController && presented is ZoomViewController {
            self.operation = true
            return self
        }
        else {
            return nil
        }
    }
}

