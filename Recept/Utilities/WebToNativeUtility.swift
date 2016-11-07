//
//  WebToNativeUtility.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-08-19.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation
open class WebToNativeUtility {
    fileprivate static let globalCallbackFunction = "NativeCallback.dispatch"
    open static func process(_ url: URL) throws -> (functionName: String?, args: Dictionary<String, AnyObject>?, callbackEvent: String?) {
        let data = url.host?.data(using: String.Encoding.utf8)
        
        if data != nil {
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                
                let function = json["functionname"] as? String
                let args = json["args"] as? Dictionary<String, AnyObject>
                let callbackEvent = json["callbackEvent"] as? String
                
                return (function, args, callbackEvent)
                
            } catch let error as NSError {
                print(error)
            }
            
            
        }
        
        throw NSError(domain: "WebToNativeUtility: Data conversion failed!", code: -1, userInfo: nil)
    }
    
    open static func callbackJavascript(_ webView: UIWebView, callbackEvent: String?, callbackArgs: Dictionary<String, AnyObject>?) throws {
        let callbackFormat = "%@(\"%@\", %@);" // NativeCallback.dispatch("callbackEventId", jsonObjectArgs)
        var callbackJavascript: String? = nil
        
        guard callbackEvent != nil else {
            throw NSError(domain: "WebToNativeUtility: callbackEvent is nil", code: -1, userInfo: nil)
        }
        
        if callbackArgs != nil {
            let jsonArgs = try JSONSerialization.data(withJSONObject: callbackArgs!, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString = NSString(data: jsonArgs, encoding: String.Encoding.utf8.rawValue)
            
            callbackJavascript =  String(format: callbackFormat,
                WebToNativeUtility.globalCallbackFunction,
                callbackEvent!,
                jsonString!)
        }
        else {
            callbackJavascript = String(format: callbackFormat,
                WebToNativeUtility.globalCallbackFunction,
                callbackEvent!,
                "null")
        }
        
        guard callbackJavascript != nil else {
            throw NSError(domain: "WebToNativeUtility: callbackJavacsript is nil", code: -1, userInfo: nil)
        }
        webView.stringByEvaluatingJavaScript(from: callbackJavascript!)
    }
    
    open static func callbackJavascript(_ webView: UIWebView, callbackEvent: String?, callbackArgsJson: String?) {
        let callbackFormat = "%@(\"%@\", %@);" // NativeCallback.dispatch("callbackEventId", jsonObjectArgs)
        var callbackJavascript: String? = nil
        
        if callbackEvent == nil {
            return
        }
        
        callbackJavascript =  String(format: callbackFormat,
                WebToNativeUtility.globalCallbackFunction,
                callbackEvent!,
                callbackArgsJson ?? "null")
        webView.stringByEvaluatingJavaScript(from: callbackJavascript!)
    }
}
