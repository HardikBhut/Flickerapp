//
//  Service.swift
//  Flickerapp
//
//  Created by Apple on 18/11/21.
//

import UIKit

class Service: NSObject {
    
    static let shareIntance = Service()
    
    func getAllPhoto(withName: String, compilation: @escaping([ImageModle]?, Error?) -> ()){
        
        let baseURL = GlobalVar.BASEURL.appending(withName)
        guard let url  = URL(string: baseURL) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if  let err = error{
                compilation(nil,err)
                print(err.localizedDescription)
            }else{
                guard let data = data else { return }
                do{
 
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    let dicData = json! as NSDictionary
                    
                    let dic  = dicData.value(forKey: "photos") as? NSDictionary
                   
                    let temparr = dic!.value(forKey: "photo")as? NSArray
                        
                    var arrPhoto = [ImageModle]()
                    
                    for i in (0..<temparr!.count) {
                        
                        let strServer = (temparr!.object(at: (i)) as! NSDictionary).value(forKey: "server") as? String
                        let strid = (temparr!.object(at: (i)) as! NSDictionary).value(forKey: "id") as? String
                        let strSecret = (temparr!.object(at: (i)) as! NSDictionary).value(forKey: "secret") as? String
                        arrPhoto.append(ImageModle(server: strServer!, id: strid!, secret: strSecret!))
                    }
                    compilation(arrPhoto, nil)

                }catch let jsonerr{
                    
                    print(jsonerr.localizedDescription)
                }
            
            }
            
        }.resume()
     }

}
