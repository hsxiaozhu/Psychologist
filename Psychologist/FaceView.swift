//
//  FaceView.swift
//  Demo
//
//  Created by 大可立青 on 15/5/17.
//  Copyright (c) 2015年 大可立青. All rights reserved.
//

import UIKit


protocol FaceViewDataSource:class{
    func smilinessForFaceView(sender:FaceView)->Double
}

@IBDesignable
class FaceView: UIView {
    
    @IBInspectable
    var lineWidth:CGFloat = 3{
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var color:UIColor = UIColor.blueColor(){
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var scale:CGFloat = 0.90{
        didSet{
            setNeedsDisplay()
        }
    }

    var faceCenter:CGPoint{
        return convertPoint(center, fromView: superview)
    }
    var faceRadius:CGFloat{
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    var dataSource:FaceViewDataSource?
    
    func scale(gesture:UIPinchGestureRecognizer){
        if gesture.state == .Changed{
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
    
    private struct Scaling{
        static let FaceRadiusToEyeRadiusRatio:CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio:CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio:CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio:CGFloat = 1
        static let FaceRadiusToMouthHeightRatio:CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio:CGFloat = 3
    }
    
    private enum Eye{
        case Left,Right
    }
    
    private func bezierPathForEye(whichEye:Eye)->UIBezierPath{
        let eyeRadius = faceRadius/Scaling.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = faceRadius/Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeparation = faceRadius/Scaling.FaceRadiusToEyeSeparationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        switch whichEye{
        case .Left:eyeCenter.x -= eyeHorizontalSeparation/2
        case .Right:eyeCenter.x += eyeHorizontalSeparation/2
        }
        
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        path.lineWidth = lineWidth
        color.set()
        return path
    }
    
    private func bezierPathForSmile(fractionOfMaxSmile:Double)->UIBezierPath{
        let mouthWidth = faceRadius/Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius/Scaling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius/Scaling.FaceRadiusToMouthOffsetRatio

        let smileHeight = CGFloat(max(min(fractionOfMaxSmile,1), -1)) * mouthHeight
        
        let start = CGPoint(x: faceCenter.x - mouthWidth/2, y: faceCenter.y + mouthVerticalOffset)
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
        let cp1 = CGPoint(x: start.x + mouthWidth / 3, y: start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: cp1.y)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        ///*笑脸
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
        
        bezierPathForEye(.Left).stroke()
        //bezierPathForEye(.Left).fill()
        bezierPathForEye(.Right).stroke()
        //bezierPathForEye(.Right).fill()
        
        let smileness = dataSource?.smilinessForFaceView(self) ?? 0.0
        let smilePath = bezierPathForSmile(smileness)
        smilePath.stroke()
        //*/
        
//        //绘制五边形
//        let fivePath = UIBezierPath()
//        fivePath.lineWidth = 5
//        fivePath.lineCapStyle = kCGLineCapRound
//        fivePath.lineJoinStyle = kCGLineJoinRound
//        //起点
//        fivePath.moveToPoint(CGPointMake(200, 100))
//        fivePath.addLineToPoint(CGPointMake(300, 140))
//        fivePath.addLineToPoint(CGPointMake(260, 240))
//        fivePath.addLineToPoint(CGPointMake(140, 240))
//        fivePath.addLineToPoint(CGPointMake(100, 140))
//        //最后一条边由closePath实现
//        fivePath.closePath()
//        
//        UIColor.cyanColor().set()
//        fivePath.fill()
//        
//        
//        //矩形
//        let rectPath = UIBezierPath(rect: CGRectMake(140, 280, 120, 120))
//        rectPath.lineWidth = 8
//        rectPath.lineCapStyle = kCGLineCapRound
//        rectPath.lineJoinStyle = kCGLineJoinRound
//        rectPath.stroke()
//        
//        let aPath = UIBezierPath(ovalInRect: CGRectMake(140, 420, 120, 120))
//        aPath.lineWidth = 8
//        aPath.fill()
//        
//        //绘制贝塞尔曲线
//        let aPath2 = UIBezierPath()
//        aPath2.lineWidth = 5.0
//        aPath2.lineCapStyle = kCGLineCapRound
//        aPath2.lineJoinStyle = kCGLineJoinRound
//        
//        aPath2.moveToPoint(CGPointMake(80, 50))
//        aPath2.addCurveToPoint(CGPointMake(260, 50), controlPoint1: CGPointMake(140, 0), controlPoint2: CGPointMake(200, 100))
//        aPath2.stroke()
    }


}
