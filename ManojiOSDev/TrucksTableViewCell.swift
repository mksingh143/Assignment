//
//  TrucksTableViewCell.swift
//  ManojiOSDev
//
//  Created by manojnkumar on 21/10/21.
//

import UIKit

class TrucksTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var truckNumberLabel: UILabel!
    @IBOutlet weak var vehicleImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeValueLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedValueLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK:- Helper methods
extension TrucksTableViewCell {
    
    func setUI(errorState : Bool) {
        self.cardView.layer.cornerRadius = 6.0
        self.cardView.layer.shadowRadius = 6.0
        self.cardView.layer.masksToBounds = false
        self.cardView.layer.shadowOpacity = 0.3
        self.cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.cardView.layer.shadowColor = UIColor.black.cgColor
        self.cardView.layer.masksToBounds = false
        if errorState {
            self.cardView.backgroundColor = .systemRed
        }else {
            self.cardView.backgroundColor = .white
        }
    }
    
    func setData(truck : TruckResult) {
        
        if truck.lastRunningState?.truckRunningState == 0 || truck.lastRunningState?.truckRunningState == 1 {
            self.setUI(errorState : false)
        }else {
            self.setUI(errorState : true)
        }
        
        self.truckNumberLabel.text = truck.truckNumber
        let tuple = self.getTimeValue(timestamp: (truck.lastWaypoint?.createTime) ?? 0)
        self.timeValueLabel.text = tuple.0
        self.timeLabel.text = tuple.1 + " ago"
        if let speed = truck.lastWaypoint?.speed {
            self.speedValueLabel.text = String(format:"%.02f", speed)
            self.speedLabel.text = "k/h"
        }
        
        let runningTime = self.getTimeValue(timestamp: (truck.lastRunningState?.stopStartTime) ?? 0)

        var runningStatus = ""
        if truck.lastRunningState?.truckRunningState == 0 {
            runningStatus = "Stopped since last \(runningTime.0) \(runningTime.1)"
            self.vehicleImageView.image = UIImage.init(named: "battery")
        }else {
            runningStatus = "Running since last \(runningTime.0) \(runningTime.1)"
            self.vehicleImageView.image = UIImage.init(named: "truck")
        }
        self.statusLabel.text = runningStatus

    }
    
    func getTimeValue(timestamp : Int) -> (String, String){
        
        let myTimeInterval = TimeInterval(timestamp)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))

        let dateStr = self.offsetFrom(date: Date(), createdDate: time as Date)

        return dateStr
    }
    
    func offsetFrom(date: Date, createdDate : Date) -> (time : String, title : String) {

        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: createdDate)

        let seconds = "\(difference.second ?? 0)"
        let minutes = "\(difference.minute ?? 0)"
        let hours = "\(difference.hour ?? 0)"
        let days = "\(difference.day ?? 0)"

        if let day = difference.day, day          > 0 {
            return (days, "days")
        }
        if let hour = difference.hour, hour       > 0 {
            return (hours, "hours")
        }
        if let minute = difference.minute, minute > 0 {
            return (minutes, "mins")
        }
        if let second = difference.second, second > 0 {
            return (seconds, "secs")
        }
        return ("", "")
    }

}
