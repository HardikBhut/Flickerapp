//
//  ImagaeViewModle.swift
//  Flickerapp
//
//  Created by Apple on 19/11/21.
//

import UIKit

class ImageViewModle: NSObject {
    
    var server : String?
    var id : String?
    var secret : String?
    
    init(Image: ImageModle){
        self.server = Image.server
        self.id = Image.id
        self.secret = Image.secret
    }

}
