//
//  ViewController.swift
//  Currencies
//
//  Created by Anton Levin on 27.11.2020.
//

import UIKit

final class FirstViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet private weak var myTableView: UITableView!
    
    private  var currency: [Currency] = [] {
        didSet {
            DispatchQueue.main.async {
                self.myTableView.reloadData()
            }
        }
    }
    
    private let provider = Provider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        provider.getData() { [weak self] in
            switch $0 {
            case let .success(value):
                debugPrint("value: \(value)")
                guard
                    let usd = value.first(where: { $0.txt == "Долар США"}),
                    let eur = value.first(where: { $0.txt == "Євро"})
                else { return }
                self?.currency.append(usd)
                self?.currency.append(eur)
            case let .failure(error):
                debugPrint("error: \(error)")
            }
        }
    }
    
    func setupTableView() {
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currency.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let data = currency[indexPath.row]
        cell.detailTextLabel?.text = "\(data.rate)"
        cell.textLabel?.text = data.cc
        return cell
    }
}
