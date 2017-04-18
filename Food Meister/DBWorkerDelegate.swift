//
//  DBWorkerDelegate.swift
//  Food Meister
//
//  Created by KYLE TOMMET on 3/1/17.
//  Copyright © 2017 KYLE TOMMET. All rights reserved.
//

import Foundation

protocol DBWorkerDelegate : class{
    func didFinishTask(returnedJSON: [String: Any]?, wasASuccess: Bool)
}
