//
//  WebViewblog.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 10. 15..
//  Copyright © 2016년 apple. All rights reserved.
//

import UIKit //ios에서 코코아 프레임워크를 사용하기 위한 것//
import Foundation

class WebViewblog : UIViewController
{
    @IBOutlet weak var webview: UIWebView!
    
    @IBAction func back_screen(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refresh_webview(_ sender: UIBarButtonItem) {
        print("refresh webview")
        
        webview.reload() //웹뷰를 새로고침//
    }
    @IBAction func backpage_button(_ sender: UIButton) {
        //현재 웹뷰에서 뒤로가기//
        webview.goBack()
    }
    
    @IBAction func forwardpage_button(_ sender: UIButton) {
        //현재 웹뷰에서 앞으로 가기//
        webview.goForward()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let url = URL (string: "http://scw0531.blog.me/")
        let requestObj = URLRequest(url: url! as URL) //Request방식으로 요청//
        
        webview.loadRequest(requestObj as URLRequest) //설정된 주소를 웹뷰에 로드//
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
