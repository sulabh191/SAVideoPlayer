//
//  BasePresenter.swift
//  VideoAnalytics
//
//  Created by Sulabh Agarwal on 06/02/17.
//  Copyright © 2017 Sulabh. All rights reserved.
//

import Foundation

public protocol BasePresenter
{
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
    func viewDidDisappear()
}

//Extended to make protocol function as optionals
public extension BasePresenter {
    func viewDidLoad() {}
    func viewWillAppear() {}
    func viewDidAppear() {}
    func viewWillDisappear() {}
    func viewDidDisappear() {}
}
