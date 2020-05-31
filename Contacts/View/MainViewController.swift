//
//  ViewController.swift
//  Contacts
//
//  Created by Daniel Savchak on 27.05.2020.
//  Copyright © 2020 Danylo-Savchak. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, ViewProtocol {
    
    let tranDelegate = ZoomTransitionDelegate(operation: true)
    var selectedIndexPath: IndexPath!
    
    var imageViewToTransition = UIImage()
    
    var presenter: ContactsPresenterProtocol!
    
    func loadContacts() {
        self.myTableView.reloadData()
        self.myCollectionView.reloadData()
    }
    
    // MARK: - lyfe cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.loadContacts()
        
        view.backgroundColor = UIColor.white
        
    }
    
    override func viewWillLayoutSubviews() {
        addSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        addConstraints()
    }
    
    // MARK: - subviews
    
    private lazy var switcher: UISegmentedControl = {
        let switcher = UISegmentedControl(items: ["List","Grid"])
        switcher.translatesAutoresizingMaskIntoConstraints = false
        switcher.selectedSegmentIndex = 0
        switcher.addTarget(self, action: #selector(switchViews), for: .valueChanged)
        return switcher
    }()
    
    private lazy var simulateChangesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Simulate Changes", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(simulateChangesButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    lazy var myTableView: UITableView = {
        let myTableView = UITableView()
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.separatorStyle = .singleLine
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(TableViewCell.self, forCellReuseIdentifier: String(describing: TableViewCell.self))
        return myTableView
    }()
    
    lazy var myCollectionView: UICollectionView = {
        let c = UICollectionView(frame: .zero, collectionViewLayout:UICollectionViewFlowLayout())
        c.translatesAutoresizingMaskIntoConstraints = false
        c.register(cellType: CollectionViewCell.self,nib: false)
        c.isHidden = true
        c.backgroundColor = .white
        c.delegate = self
        c.dataSource = self
        return c
    }()
    
    private func addSubviews() {
        view.addSubview(switcher)
        view.addSubview(simulateChangesButton)
        view.addSubview(myTableView)
        view.addSubview(myCollectionView)
    }
    
    // MARK: - constraints
    
    private func addConstraints() {
        setSwitcherConstraints()
        setSimulateChangesButtonConstraints()
        setTableViewConstraints()
        setCollectionViewConstraints()
    }
    
    private func setSwitcherConstraints() {
        switcher.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        switcher.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        switcher.heightAnchor.constraint(equalToConstant: 30).isActive = true

    }
    
    private func setSimulateChangesButtonConstraints() {
        NSLayoutConstraint.activate([simulateChangesButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),simulateChangesButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),simulateChangesButton.heightAnchor.constraint(equalToConstant: 20)])
    }
    
    private func setTableViewConstraints() {
        myTableView.topAnchor.constraint(equalTo: switcher.bottomAnchor, constant: 16).isActive = true
        myTableView.bottomAnchor.constraint(greaterThanOrEqualTo: simulateChangesButton.topAnchor, constant: -16).isActive = true
        myTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        myTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
    }
    
    private func setCollectionViewConstraints() {
        myCollectionView.topAnchor.constraint(equalTo: switcher.bottomAnchor, constant: 16).isActive = true
        myCollectionView.bottomAnchor.constraint(greaterThanOrEqualTo: simulateChangesButton.topAnchor, constant: -16).isActive = true
        myCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        myCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
    }
    
    
    // MARK: - actions
    
    @objc private func simulateChangesButtonPressed(){
        presenter.simulateChanges()
    }
    
    @objc private func switchViews() {
        if switcher.selectedSegmentIndex == 0 {
            myTableView.isHidden = false
            myCollectionView.isHidden = true
            switcher.selectedSegmentIndex = 0
        } else {
            myTableView.isHidden = true
            myCollectionView.isHidden = false
            switcher.selectedSegmentIndex = 1
        }
    }
}
    
// MARK: - Table view data source
extension MainViewController: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count =  presenter.contactsData.count
        return count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: String(describing : TableViewCell.self)) as! TableViewCell
        cell.setData(isOnline: presenter.contactsData[indexPath.row].isOnline, text: presenter.contactsData[indexPath.row].name, photo: presenter.contactsData[indexPath.row].photo)
        return cell
    }
}

//MARK: - Table view delegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        self.selectedIndexPath = indexPath
        vc.userInfo = self.presenter.contactsData[indexPath.item]
        vc.modalPresentationStyle = .fullScreen
        vc.transitioningDelegate = self.tranDelegate
        self.present(vc, animated: true, completion: nil)
        myTableView.deselectRow(at: indexPath, animated: true)
    }
}
//MARK: - write register & dequeueCell functions fo Collection View
extension UICollectionView {
    func register<Cell: UICollectionViewCell>(cellType: Cell.Type, nib: Bool = true) {
            
        let reuseIdentifier = String(describing: cellType)
            
        if nib {
            let nib = UINib(nibName: reuseIdentifier, bundle: nil)
            register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        } else {
            register(cellType, forCellWithReuseIdentifier: reuseIdentifier)
        }
    }
        
    func dequeueCell<Cell: UICollectionViewCell>(of cellType: Cell.Type,
                                                     for indexPath: IndexPath) -> Cell {
            
        return dequeueReusableCell(withReuseIdentifier: String(describing: cellType),
                                       for: indexPath) as! Cell
    }
}

//MARK: - CollectionView datasource & delegate
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.contactsData.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.setPhoto(image: presenter.contactsData[indexPath.item].photo, isOnline: presenter.contactsData[indexPath.item].isOnline)
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50.0, height: 50.0)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.userInfo = self.presenter.contactsData[indexPath.item]
        vc.modalPresentationStyle = .fullScreen
        vc.transitioningDelegate = self.tranDelegate
        self.selectedIndexPath = indexPath
        self.present(vc, animated: true, completion: nil)
        myCollectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension MainViewController: ZoomViewController {
    func zoomingImageView(for transition: ZoomTransitionDelegate) -> UIImageView? {
        if let indexPath = selectedIndexPath {
            if myTableView.isHidden == true {
                let cell = myCollectionView.cellForItem(at: indexPath) as! CollectionViewCell
                return cell.avatar
            } else {
                let cell: TableViewCell = myTableView.cellForRow(at: indexPath) as! TableViewCell
                return cell.myImageView
            }
        }
        return nil
    }
    
    func zoomingBackgroundView(for transition: ZoomTransitionDelegate) -> UIView? {
        return nil
    }
    
    
}

