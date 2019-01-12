//
//  WebViewController.swift
//  WiredFeedsTestApp
//
//  Created by Володимир Ільків on 1/12/19.
//  Copyright © 2019 Володимр Ільків. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    //  MARK: - IBOutlets

    @IBOutlet private weak var feedWebView: WKWebView!
    
    //MARK: - Properties
    
    public var urlString : String?
    
    //MARK: - Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        urlString =  urlString?.replacingOccurrences(of: " ", with:"")
        urlString =  urlString?.replacingOccurrences(of: "\n", with:"")
        feedWebView.load(URLRequest(url: URL(string: urlString! as String)!))
    }
    
}
