//
//  ViewController.swift
//  Travel-Schedule
//
//  Created by 1111 on 28.04.2025.
//

import UIKit
import OpenAPIURLSession
import SwiftUI

final class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controller = UIHostingController(rootView: TabScreenView())
        self.addChild(controller)
        self.view.addSubview(controller.view)
        controller.didMove(toParent: self)
        controller.view.frame = view.frame
    }
}
