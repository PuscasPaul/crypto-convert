//
//  ViewController.swift
//  CoinExchange
//
//  Created by Puscas Paul on 15.07.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var labelConvertText: UILabel!
    @IBOutlet weak var firstCurrency: UILabel!
    @IBOutlet weak var secondCurrency: UILabel!
    @IBOutlet weak var valueOfCurrencyPicked: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var coinManager = CoinManager()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        coinManager.delegate = self
    }
}

// MARK: - CoinManager Delegate
extension ViewController: CoinManagerDelegate {
    func lastPrice(_ bitcoinPrice: CoinManager, coin: CoinData) {
        DispatchQueue.main.async {
            self.firstCurrency.text = coin.asset_id_base
            
            self.valueOfCurrencyPicked.text = String(format: "%.2f", coin.rate)

            self.secondCurrency.text = coin.asset_id_quote
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

// MARK: - UI PickerView Delegate
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return coinManager.firstCurrencyArray.count
        } else {
            return coinManager.secondCurrencyArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return coinManager.firstCurrencyArray[row]
        } else {

            return coinManager.secondCurrencyArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let firstCurrencyPicked = coinManager.firstCurrencyArray[pickerView.selectedRow(inComponent: 0)]
        let secondCurrencyPicked = coinManager.secondCurrencyArray[pickerView.selectedRow(inComponent: 1)]

        labelConvertText.text = "Convert \(firstCurrencyPicked) to \(secondCurrencyPicked)"
        coinManager.getCoinPrice(firstCurrency: firstCurrencyPicked, secondCurrency: secondCurrencyPicked)
    }
}
