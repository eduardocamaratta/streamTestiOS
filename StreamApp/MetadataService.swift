//
//  MetadataService.swift
//  StreamApp
//
//  Copyright © 2019 Eduardo Camaratta. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MetadataService {
    static fileprivate let jsonUrl = "http://www.antenne.com/services/program-info/live/antenne"
    static fileprivate let streamName = "Z80er"

    // Gets the current metadata for the streaming
    static func getMetadata(completion: @escaping (String?, String?, String?) -> Void) {
        Alamofire.request(MetadataService.jsonUrl, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON {response in
                switch response.result {
                case .success:
                    if let result = response.result.value {
                        let json = JSON(result).arrayValue
                        if let selectedStream = json.first(where: { (stream) -> Bool in
                            return stream["name"].string == MetadataService.streamName
                        }) {
                            completion(selectedStream["playHistories"][0]["track"]["title"].string,
                                       selectedStream["playHistories"][0]["track"]["artist"].string,
                                       selectedStream["playHistories"][0]["track"]["itunesCoverMedium"].string)
                        }
                    } else {
                        completion(nil, nil, nil)
                    }
                case .failure:
                    completion(nil, nil, nil)
                }
            }
    }

    // Returns the image from an URL
    static func getImage(url: String, completion: @escaping (Data?) -> Void) {
        Alamofire.request(url, method: .get, parameters: nil).response { (response) in
            guard 200..<300 ~= response.response?.statusCode ?? 500 else {
                completion(nil)
                return
            }

            if let data = response.data {
                completion(data)
            } else {
                completion(nil)
            }
        }
    }
}
