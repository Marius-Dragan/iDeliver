//
//  UIViewExt.swift
//  iDeliver
//
//  Created by Marius Dragan on 17/12/2017.
//  Copyright © 2017 Marius Dragan. All rights reserved.
//

import UIKit

extension UIView {
    func fadeTo(alphaValue: CGFloat, withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.alpha = alphaValue
        }
    }
}
