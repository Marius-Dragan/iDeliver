//
//  ViewController.swift
//  iDeliver
//
//  Created by Marius Dragan on 26/11/2017.
//  Copyright © 2017 Marius Dragan. All rights reserved.
//

import UIKit
import RevealingSplashView

enum SortButtonAction {
    case sortArrayByDistance
    case sortArrayByPostcode
    case restoreOriginalArray
}

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, DataSentDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var distanceToDestinationLbl: UILabel!
    @IBOutlet weak var sortLbl: UIBarButtonItem!
    
    //Create array which will return your address data
    var originalArr = [DeliveryDestinations]()
    var addressArr = [DeliveryDestinations]()
    
    var actionForButton: SortButtonAction = .sortArrayByDistance

   //var isTapped: Bool = false
    var isTapped = UIButton()
    var countTaps = 0
    
    let revealingSplashView = RevealingSplashView (iconImage: UIImage(named: "LaunchScreenIcon")!, iconInitialSize: CGSize(width: 100, height: 100), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(revealingSplashView)
        revealingSplashView.animationType = SplashAnimationType.heartBeat
        revealingSplashView.startAnimation()
        revealingSplashView.heartAttack = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        isTapped.addTarget(self, action: #selector(self.sortBtnWasPressed), for: .touchUpInside)
    }
    
    //add parameter for created address object
    func userDidEnterData(addressObj: DeliveryDestinations) {
        
        //append added object into your table array
        self.originalArr.append(addressObj)
        //Copy originalArr to addressArr to revert back to how user input the data
        addressArr = originalArr
        //Reload your tableview once your new object added.
        self.tableView.reloadData()
       
    }
//    override func viewWillAppear(_ animated: Bool) {
//        isTapped = false
//        sortLbl.title = "SORT"
//    }
//    func sortArray()  {
//        addressArr.sort { $0.DistanceToDestination < $1.DistanceToDestination}  // sort the distance A-Z
//        self.tableView.reloadData()
//        print(addressArr)
//    }
//    func restoreArray() {
//        addressArr = originalArr
//        self.tableView.reloadData()
//        print(addressArr)
//    }

    @IBAction func sortBtnWasPressed(_  sender: Any) {
        checkButtonState(sender: isTapped)
//        isTapped = !isTapped
//        if isTapped {
//            sortLbl.title = "RESTORE"
//            sortArray()
//        } else  {
//            self.sortLbl.title = "SORT"
//            restoreArray()
//        }
    }

    func checkButtonState(sender: UIButton) {
        countTaps = countTaps + 1
        print(countTaps)
        if countTaps <= 3 {
            switch countTaps  {
            case 1:
                buttonSelector(forAction: .sortArrayByDistance)
            case 2:
                buttonSelector(forAction: .sortArrayByPostcode)
            default:
                buttonSelector(forAction: .restoreOriginalArray)
                 countTaps = 0
            }
        }
    }
    func buttonSelector(forAction action: SortButtonAction) {
        switch action {
        case .sortArrayByDistance:
            // setup code to sort array by distance
            if addressArr.count > 1 {
                addressArr.sort { $0.DistanceToDestination < $1.DistanceToDestination}  // sort the distance A-Z
                sortLbl.title = "BY DISTANCE"
                tableView.reloadData()
                print(addressArr)
            }
        case .sortArrayByPostcode:
            // setup code to sort array by postcode
            if addressArr.count > 1 {
                addressArr.sort { $0.PostcodeLineAddress < $1.PostcodeLineAddress}  // sort the distance A-Z
                sortLbl.title = "BY POSTCODE"
                tableView.reloadData()
                print(addressArr)
            }
        case .restoreOriginalArray:
            // setup code to restore array to original
            if addressArr.count > 1 {
                addressArr = originalArr
                sortLbl.title = "RESTORE"
                tableView.reloadData()
                print(addressArr)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //change this with array count
        return addressArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "deliveryAddressCell", for: indexPath) as! AddressCell
        //get address object from array which you can assign to cell
        let addressObj = addressArr[indexPath.row]
        //assign data from array
        cell.updateUI(addressObj: addressObj)
        cell.numberLbl.text = String(indexPath.row + 1)
        return cell
    
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addDeliveryAddressVC" {
            let barBtm = UIBarButtonItem()
            barBtm.title = ""
            navigationItem.backBarButtonItem = barBtm
            let addDestination:AddingDestinationVC = segue.destination as! AddingDestinationVC
            addDestination.delegate = self
        } else if segue.identifier == "deliveryLocationVC" {
                let barBtm2 = UIBarButtonItem()
                barBtm2.title = ""
                navigationItem.backBarButtonItem = barBtm2
            if let deliveryLocationVC = segue.destination as? DeliveryLocationsVC {
                deliveryLocationVC.addressArr = addressArr
                }
            }
        }
    }

