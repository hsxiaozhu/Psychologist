//
//  HappinessViewController.swift
//  Psychologist
//
//  Created by 大可立青 on 15/5/29.
//  Copyright (c) 2015年 大可立青. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController,FaceViewDataSource {
    @IBOutlet weak var faceView: FaceView!{
        didSet{
            faceView.dataSource = self
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: "scale:"))
        }
    }
    var happiness:Int = 75{
        didSet{
            happiness = min(max(happiness,0),100)
            print("happiness=\(happiness)")
            updateUI()
        }
    }
    
    private func updateUI(){
        faceView?.setNeedsDisplay()
        title = "\(happiness)"
    }
    
    private struct Constant{
        static let HappinessGestureScale:CGFloat = 4
    }
    
    @IBAction func changeHappiness(gesture: UIPanGestureRecognizer) {
        switch gesture.state{
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(faceView)
            let happinessChange = -Int(translation.y / Constant.HappinessGestureScale)
            if happinessChange != 0{
                happiness += happinessChange
                gesture.setTranslation(CGPointZero, inView: faceView)
            }
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func smilinessForFaceView(sender: FaceView) -> Double {
        return Double(happiness-50)/50
    }
}
