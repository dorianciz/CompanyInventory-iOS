//
//  AnimationFactory.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 3/27/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import UIKit

class AnimationBlock {
    let duration: TimeInterval
    let delay: TimeInterval
    let animations: (() -> Void)
    let completion: (() -> Void)
    let options: UIViewAnimationOptions
    
    init(withDuration duration: TimeInterval, withDelay delay: TimeInterval, withAnimations animations: @escaping() -> Void, withCompletion completion: @escaping() -> Void, withOptions options: UIViewAnimationOptions) {
        self.duration = duration
        self.delay = delay
        self.animations = animations
        self.completion = completion
        self.options = options
    }
}

class AnimationChainingFactory {

    private(set) var animationBlocks: [AnimationBlock]
    var finallyBlock: (()->Void)?
    var initiallyBlock: (()->Void)?
    
    static let sharedInstance = AnimationChainingFactory()
    
    init() {
        animationBlocks = [AnimationBlock]()
    }
    
    func animation(withDuration duration: TimeInterval, withDelay delay: TimeInterval, withAnimations animations: @escaping() -> Void, withCompletion completion: @escaping() -> Void, withOptions options: UIViewAnimationOptions) -> AnimationChainingFactory {
        animationBlocks.append(AnimationBlock(withDuration: duration, withDelay: delay, withAnimations: animations, withCompletion: completion, withOptions: options))
        return self
    }
    
    func initially(_ block: @escaping()->Void) -> AnimationChainingFactory {
        initiallyBlock = block
        return self
    }
    
    func finally(_ block: @escaping()->Void) -> AnimationChainingFactory {
        finallyBlock = block
        return self
    }
    
    func run() {
        if let block = initiallyBlock {
            block()
        }
        runAnimations(withIndex: 0)
    }
    
    private func runAnimations(withIndex index: Int) {
        if animationBlocks.count > index {
            let currentAnimation: AnimationBlock = animationBlocks[index]
            UIView.animate(withDuration: currentAnimation.duration, delay: currentAnimation.delay, options: currentAnimation.options, animations: {
                currentAnimation.animations()
            }, completion: { finished in
                if finished {
                    currentAnimation.completion()
                    self.runAnimations(withIndex: index + 1)
                }
            })
        } else {
            if let block = finallyBlock {
                block()
            }
        }
    }
    
}
