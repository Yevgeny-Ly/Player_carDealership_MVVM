//
//  ActivityViewCustonActivity.swift
//  Player_carDealership_MVVM
//

import SwiftUI

class ActivityViewCustonActivity: UIActivity {
    
    //MARK: - Properties
    var customActivityType: UIActivity.ActivityType
    var activityName: String
    var activityImageName: String
    var customActionWhenTapped: () ->()
    
    //MARK: - Initializer
    init(title: String, imageName: String, performAction: @escaping () -> Void) {
        self.activityName = title
        self.activityImageName = imageName
        self.customActivityType = UIActivity.ActivityType(rawValue: "Action \(title)")
        self.customActionWhenTapped = performAction
        super.init()
    }

    
    //MARK: - Overrides
    override var activityType: UIActivity.ActivityType? {
        customActivityType
    }
    
    override var activityTitle: String? {
        activityName
    }
    
    override class var activityCategory: UIActivity.Category {
        .share
    }
    
    override var activityImage: UIImage? {
        UIImage(named: activityImageName)?.withRenderingMode(.alwaysOriginal)
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        true
    }
    
    override func prepare(withActivityItems activityItems: [Any]) {}
    
    override func perform() {
        customActionWhenTapped()
    }
}
