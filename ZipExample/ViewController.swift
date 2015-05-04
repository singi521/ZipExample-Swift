//
//  ViewController.swift
//  ZipExample
//
//  Created by vincentyen on 5/4/15.
//  Copyright (c) 2015 Fun Anima Co., Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController,ZipArchiveDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func upload(){
        let url = NSURL(string:"")
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var request = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 2.0)
        request.HTTPMethod = "POST"
        
        // set Content-Type in HTTP header
        let boundaryConstant = "----------V2ymHFg03esomerandomstuffhbqgZCaKO6jy";
        let contentType = "multipart/form-data; boundary=" + boundaryConstant
        NSURLProtocol.setProperty(contentType, forKey: "Content-Type", inRequest: request)
        
        // set data
        var dataString = ""
        let requestBodyData = (dataString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = requestBodyData
        
        // set content length
        //NSURLProtocol.setProperty(requestBodyData.length, forKey: "Content-Length", inRequest: request)
        
        var response: NSURLResponse? = nil
        var error: NSError? = nil
        let reply = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&error)
        
        let results = NSString(data:reply!, encoding:NSUTF8StringEncoding)
        println("API Response: \(results)")
        
    }
    @IBAction func onTappedButton(sender: AnyObject) {
        createZip()
    }
    
    func createZip(){
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        var cachtPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, .UserDomainMask, true)[0] as NSString
        
        var zip = ZipArchive()
        zip.delegate = self
        
        
        let zipFile = documentsPath.stringByAppendingString("/test.zip")
        
        var image1Path = documentsPath.stringByAppendingString("340x150.jpg")
        var image2Path = documentsPath.stringByAppendingString("948x225.jpg")
        
        var ret = zip.CreateZipFile2(zipFile)
        ret = zip.addFileToZip(image1Path, newname: "image1.jpg")
        ret = zip.addFileToZip(image2Path, newname: "image2.jpg")
        
        if !zip.CloseZipFile2() {
            println("failed")
        }else{
            println("done")
        }
    }
    
    func unZip(){
        var filePath = NSBundle.mainBundle().pathForResource("Archive", ofType: "zip")
        var zip = ZipArchive()
        zip.UnzipOpenFile(filePath)
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        println("documentsPath:\(documentsPath)")
        //[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]
        zip.UnzipFileTo(documentsPath, overWrite: true)
        zip.CloseZipFile2()

    }
    
    func ErrorMessage(msg: String!) {
        println("ErrorMessage")
    }
    
    func OverWriteOperation(file: String!) -> Bool {
        return true
    }


}

