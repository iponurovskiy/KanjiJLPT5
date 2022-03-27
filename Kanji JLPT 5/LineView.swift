//
//  LineView.swift
//  Kanji Book 5
//
//  Created by Ivan on 24/08/2018.
//

import UIKit

class LineView: UIView {
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    public override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    context!.setLineWidth(2.0)
    context!.setStrokeColor(UIColor.black.cgColor)
    context?.move(to: CGPoint(x: 0, y: self.frame.size.height))
    context?.addLine(to: CGPoint(x: self.frame.size.width, y: 0))
    context!.strokePath()
 }

}
