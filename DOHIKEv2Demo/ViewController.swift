//
//  ViewController.swift
//  DOHIKEv2Demo
//
//  Created by Juraj Hilje on 19/02/2021.
//

import UIKit

class ViewController: UITableViewController {
    
    // MARK: - @IBActions -
    
    @IBAction func connect(_ sender: UIButton) {
        VPNManager.shared.connect()
    }
    
    @IBAction func disconnect(_ sender: UIButton) {
        VPNManager.shared.disconnect()
    }
    
}
