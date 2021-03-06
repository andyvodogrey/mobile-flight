//
//  ServoConfigViewController.swift
//  Mobile Flight
//
//  Created by Raphael Jean-Leconte on 01/01/16.
//  Copyright © 2016 Raphael Jean-Leconte. All rights reserved.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import UIKit
import DownPicker
import SVProgressHUD
import Firebase

class ServoConfigViewController: UITableViewController {
    @IBOutlet weak var minimumRangeField: NumberField!
    @IBOutlet weak var middleRangeField: NumberField!
    @IBOutlet weak var maximumRangeField: NumberField!
    @IBOutlet weak var minimumAngleField: NumberField!
    @IBOutlet weak var maximumAngleField: NumberField!
    @IBOutlet weak var rateField: NumberField!
    @IBOutlet weak var rcChannelField: UITextField!

    var rcChannelPicker: DownPicker!
    var servoIdx: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // FIXME Get MSP_RC to get number of RC channels
        var channels = ["(None)"]
        for i in 0 ..< 12  {
            channels.append(ReceiverViewController.channelLabel(i))
        }
        rcChannelPicker = DownPicker(textField: rcChannelField, withData: channels)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = String(format: "Servo %d", servoIdx + 1)
        
        refreshAction(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveIfNeeded()
    }

    func saveIfNeeded() {
        Analytics.logEvent("servo_saved", parameters: nil)
        let settings = Settings.theSettings
        if settings.servoConfigs == nil || settings.servoConfigs!.count <= servoIdx {
            return
        }
        let servoConfig = settings.servoConfigs![servoIdx]
        
        let newServoConfig = ServoConfig(
            minimumRC: Int(round(minimumRangeField.value)),
            middleRC: Int(round(middleRangeField.value)),
            maximumRC: Int(round(maximumRangeField.value)),
            rate: Int(round(rateField.value)),
            minimumAngle: Int(round(minimumAngleField.value)),
            maximumAngle: Int(round(maximumAngleField.value)),
            rcChannel: (rcChannelPicker.selectedIndex < 1 ? nil : (rcChannelPicker.selectedIndex - 1)),
            reversedSources: servoConfig.reversedSources
        )
        
        var somethingChanged = servoConfig.minimumRC != newServoConfig.minimumRC
        somethingChanged = somethingChanged || servoConfig.middleRC != newServoConfig.middleRC
        somethingChanged = somethingChanged || servoConfig.maximumRC != newServoConfig.maximumRC
        somethingChanged = somethingChanged || servoConfig.minimumAngle != newServoConfig.minimumAngle
        somethingChanged = somethingChanged || servoConfig.maximumAngle != newServoConfig.maximumAngle
        somethingChanged = somethingChanged || servoConfig.rate != newServoConfig.rate
        somethingChanged = somethingChanged || servoConfig.rcChannel != newServoConfig.rcChannel
        
        if somethingChanged {
            msp.setServoConfig(servoIdx, servoConfig: newServoConfig, callback: { success in
                if success {
                    self.msp.sendMessage(.msp_EEPROM_WRITE, data: nil, retry: 2, callback: { success in
                        if !success {
                            self.showError()
                        } else {
                            self.showSuccess()
                        }
                    })
                } else {
                    self.showError()
                }
            })
        }
    }
    
    func showError() {
        DispatchQueue.main.async(execute: {
            Analytics.logEvent("servo_saved_failed", parameters: nil)
            SVProgressHUD.showError(withStatus: "Save failed")
        })
    }
    func showSuccess() {
        DispatchQueue.main.async(execute: {
            SVProgressHUD.showSuccess(withStatus: "Settings saved")
        })
    }

    @IBAction func refreshAction(_ sender: Any) {
        let settings = Settings.theSettings
        
        if settings.servoConfigs != nil && settings.servoConfigs!.count > servoIdx {
            let servoConfig = settings.servoConfigs![servoIdx]
            
            minimumRangeField.value = Double(servoConfig.minimumRC)
            middleRangeField.value = Double(servoConfig.middleRC)
            maximumRangeField.value = Double(servoConfig.maximumRC)
            minimumAngleField.value = Double(servoConfig.minimumAngle)
            maximumAngleField.value = Double(servoConfig.maximumAngle)
            rateField.value = Double(servoConfig.rate)
            rcChannelPicker.selectedIndex = servoConfig.rcChannel == nil ? -1 : servoConfig.rcChannel! + 1
        }
        tableView.reloadData()
    }
}
