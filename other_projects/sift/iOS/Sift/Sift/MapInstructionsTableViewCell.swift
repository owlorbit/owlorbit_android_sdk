//
//  UserSearchTableViewCell.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/25/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage.Swift

class MapInstructionsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblInstruction: UILabel!

    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var imgDirection: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func populate(routeStep:MKRouteStep){
        lblInstruction.text = routeStep.instructions
        lblDistance.text = String(format:"%.1f miles", (0.00062137 * routeStep.distance))
        processImageDirection(routeStep.instructions)
    }

    func processImageDirection(var direction:String){
        direction = direction.lowercaseString
        
        if(direction.containsString("continue onto") || direction.containsString("proceed")){
            imgDirection.image = UIImage(named:"direction_continue_icon")
        }else if(direction.containsString("exit right") || direction.containsString("turn right")){
            imgDirection.image = UIImage(named:"direction_right_icon")
        }else if(direction.containsString("exit left") || direction.containsString("turn left")){
            imgDirection.image = UIImage(named:"direction_left_icon")

            
        }else if(direction.containsString("keep left")){
            imgDirection.image = UIImage(named:"direction_keep_left_icon")
        }else if(direction.containsString("keep right")){
            imgDirection.image = UIImage(named:"direction_keep_right_icon")
        }else if(direction.containsString("merge onto")){
            imgDirection.image = UIImage(named:"direction_merge_icon")
        }else if(direction.containsString("arrive at")){
            imgDirection.image = UIImage(named:"direction_destination_icon")
        }else if(direction.containsString("take exit")){
            imgDirection.image = UIImage(named:"direction_exit_icon")
        }else{
            imgDirection.image = nil
        }
        
    }
    
    func populateFirstCell(routeStep:MKRouteStep){
        
        var typeOfTransportation:String = "driving"
        if(routeStep.transportType ==  MKDirectionsTransportType.Automobile){
            typeOfTransportation = "driving"
        }else if(routeStep.transportType ==  MKDirectionsTransportType.Walking){
            typeOfTransportation = "walking"
        }else if(routeStep.transportType ==  MKDirectionsTransportType.Transit){
            typeOfTransportation = "transit"
        }
        
        lblInstruction.text = routeStep.instructions + " by " + typeOfTransportation
        lblDistance.text = "";
        processImageDirection(routeStep.instructions)
    }

    
    class func cellHeight()->CGFloat{
        return 88.0
    }
    
}
