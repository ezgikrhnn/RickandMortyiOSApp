//
//  RMLocationView.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 20.03.2024.
//

/**
 CONFIGURE FONKSİYONU:
    Genellikle veri modelinin görünüme aktarılmasında kullanılır. Ben de çalışmamda viewmodel tarafından çekilen verilerin viewe aktarılmasında kullandım.
 
 view'e viewModel'ı configuration ile bağladım.
 controllera viewModel'i viewmodelin delegate'i ile bağlayacağım.
 */

import UIKit

final class RMLocationView: UIView {

    //VIEWMODEL
    private var viewModel : RMLocationViewViewModel?{
        didSet{ //viewmodele her yeni deger atandıgında
            spinner.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            UIView.animate(withDuration: 0.3) {
                self.tableView.alpha = 1
            }
        }
    }
    
    //TABLEVIEW
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.alpha = 0
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    
    //SPINNER
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    //MARK: -Init
    override init(frame: CGRect){
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(tableView, spinner)
        spinner.startAnimating()
        addConstraints()
        configureTable()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureTable(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //VİEWMODEL KURULUMU: verileri viewe aktar
    public func configure(with viewModel: RMLocationViewViewModel){
        self.viewModel = viewModel
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
         
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

//TABLEVİEW FONKSİYONLARI
extension RMLocationView: UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RMLocationView: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "label"
        return cell
    }
}
