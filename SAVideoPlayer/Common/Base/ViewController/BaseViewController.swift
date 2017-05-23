//
//  BaseViewController.swift
//  VideoAnalytics
//
//  Created by Sulabh Agarwal on 06/02/17.
//  Copyright © 2017 Sulabh. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController,BaseProtocolUI {
    
    public var presenter:BasePresenter! = nil

    public override func viewDidLoad() {
        super.viewDidLoad()
        if (presenter != nil)
        {
            presenter.viewDidLoad()
        }
        // Do any additional setup after loading the view.
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (presenter != nil) {
            presenter.viewWillAppear()
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (presenter != nil) {
            presenter.viewDidAppear()
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (presenter != nil) {
            presenter.viewWillDisappear()
        }
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if (presenter != nil) {
            presenter.viewDidDisappear()
        }
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
