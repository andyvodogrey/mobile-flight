//
//  MultiTypes.swift
//  Cleanflight Configurator
//
//  Created by Raphael Jean-Leconte on 07/12/15.
//  Copyright © 2015 Raphael Jean-Leconte. All rights reserved.
//

import UIKit

class MultiTypes {
    static let label = [ "Tricopter", "Quad +", "Quad X", "Bicopter", "Gimbal", "Y6", "Hex +", "Flying Wing", "Y4", "Hex X", "Octo X8", "Octo Flat +", "Octo Flat X", "Airplane", "Heli 120", "Heli 90", "V-tail Quad", "Hex H", "PPM to SERVO", "Dualcopter", "Singlecopter", "A-tail Quad", "Custom"]
    static let drawings = [ "tri", "quad_p", "quad_x", "bicopter", "custom", "y6", "hex_p", "flying_wing", "y4", "hex_x", "octo_x8", "octo_flat_p", "octo_flat_x", "airplane", "custom", "custom", "vtail_quad", "custom", "custom", "custom", "custom", "atail_quad", "custom"]
    
    static func getDescription(multiType: Int) -> String {
        return label[multiType - 1];
    }
    static func getImage(multiType: Int) -> UIImage {
        return UIImage(imageLiteral: drawings[multiType - 1])
    }
}