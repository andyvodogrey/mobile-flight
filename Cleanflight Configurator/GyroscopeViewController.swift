//
//  GyroscopeViewController.swift
//  Cleanflight Configurator
//
//  Created by Raphael Jean-Leconte on 04/12/15.
//  Copyright © 2015 Raphael Jean-Leconte. All rights reserved.
//

import UIKit
import Charts

class GyroscopeViewController: XYZSensorViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let leftAxis = chartView.leftAxis;
        leftAxis.customAxisMax = 2000;
        leftAxis.customAxisMin = -2000;
        
        chartView.leftAxis.valueFormatter = NSNumberFormatter()
        chartView.leftAxis.valueFormatter?.maximumFractionDigits = 0
    }

    override func updateSensorData() {
        let sensorData = SensorData.theSensorData
        
        xSensor.append(sensorData.gyroscopeX);
        ySensor.append(sensorData.gyroscopeY);
        zSensor.append(sensorData.gyroscopeZ);
    }
}
