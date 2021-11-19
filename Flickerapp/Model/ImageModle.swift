//
//  ImageModle.swift
//  Flickerapp
//
//  Created by Apple on 18/11/21.
//

import UIKit

class ImageModle: Decodable {

    var server : String?
    var id : String?
    var secret : String?
    
    init(server : String, id : String, secret : String){
        
        self.server = server
        self.id = id
        self.secret = secret
        
    }
}


class PhotoModle : Decodable {
    
    var photo = [ImageModle]()
    
    init(photo : [ImageModle]){
        self.photo = photo
    }
}
