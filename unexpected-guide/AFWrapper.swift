//
//  AFWrapper.swift
//  unexpected-guide
//
//  Created by 진형탁 on 2017. 2. 11..
//  Copyright © 2017년 fail-nicely. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AFWrapper: NSObject {
    class func requestGETURL(_ strURL: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        Alamofire.request(strURL).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    class func requestPOSTURL(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        
        Alamofire.request(strURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
}
// how to use
    /*
        AFWrapper.requestGETURL(requestUrl, success: {
            (JSONResponse) -> Void in
            // suucess to get response
            self.arrRes = JSONResponse.arrayObject as! [[String:AnyObject]]
            print(self.arrRes)
            if self.arrRes.count > 0 {
                print(self.arrRes[0]["thumbImageId"]) //test
            }
        }) {
            // fail
            (error) -> Void in
            print(error)
        }
 */
        
