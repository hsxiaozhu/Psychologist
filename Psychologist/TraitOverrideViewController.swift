//
//  TraitOverrideViewController.swift
//  Psychologist
//
//  Created by 大可立青 on 15/6/13.
//  Copyright © 2015年 大可立青. All rights reserved.
//

import UIKit

class TraitOverrideViewController: UIViewController {

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        var trait : UITraitCollection?
        if size.width > 414{
            trait = UITraitCollection(horizontalSizeClass: UIUserInterfaceSizeClass.Regular)
        }else{
            trait = UITraitCollection(horizontalSizeClass: UIUserInterfaceSizeClass.Compact)
        }
        setOverrideTraitCollection(trait, forChildViewController: childViewControllers.first as UIViewController!)
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }

}
