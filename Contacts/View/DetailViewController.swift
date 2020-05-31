//
//  DetailViewController.swift
//  Contacts
//
//  Created by Daniel Savchak on 30.05.2020.
//  Copyright © 2020 Danylo-Savchak. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var userInfo: User?
    
    private var centerConstraints: ([NSLayoutConstraint], [NSLayoutConstraint]) = ([], [])
    
    private func addData() {
        if let userInfo = userInfo {
            imageView.image = userInfo.photo
            imageView.backgroundColor = .black
            if traitCollection.horizontalSizeClass == .compact {
                 imageView.frame = CGRect(x: .zero, y: .zero, width: self.view.frame.width/2, height: self.view.frame.width/2)
                imageView.layer.cornerRadius = (imageView.frame.width)/2
                
            } else {
                imageView.frame = CGRect(x: .zero, y: .zero, width: self.view.frame.height/4, height: self.view.frame.height/4)
                imageView.layer.cornerRadius = (imageView.frame.width)/2
            }
            imageView.clipsToBounds = true
            nameLabel.text = userInfo.name
            if userInfo.isOnline {
                statusLabel.text = "online"
            } else {statusLabel.text = "offline"}
            mailLabel.text = userInfo.email
        }
    }
    //MARK: - lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        transitioningDelegate = d
        view.backgroundColor = UIColor.white
    }
    
    override func viewWillLayoutSubviews() {
        addSubviews()
        addData()
    }
    
    override func viewDidLayoutSubviews() {
        centerConstraints = ([],[])
        addConstrainsts()
        activateCenterConstraints()
    }
    
    //MARK: - subviews
    
    var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 50)
        label.textAlignment = .center
        return label
    }()
    
    var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 30)
        label.textAlignment = .center
        return label
    }()
    
    var mailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.systemBlue
        label.font = UIFont.systemFont(ofSize: 40)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    private func addSubviews() {
        self.view.addSubview(backButton)
        self.view.addSubview(imageView)
        self.view.addSubview(nameLabel)
        self.view.addSubview(statusLabel)
        self.view.addSubview(mailLabel)
    }
    
    //MARK: - constraints
    
    private func setBackButtonConstraints() {
        backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        backButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
    }
    
    private func setImageViewConstraints() {
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -20).isActive = true
        centerConstraints.0 += [
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        ]
        centerConstraints.1 += [
            imageView.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25)
        ]
    }
    
    private func seNameLabelConstraints() {
        centerConstraints.0 += [
            nameLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor,constant: -20),
            nameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ]
        centerConstraints.1 += [
            nameLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor,constant: 100),
            nameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ]
    }
    
    private func setStatusLabelConstraints() {
        statusLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20).isActive = true

    }
    
    private func setMailLabelConstraints() {
        mailLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        mailLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 20).isActive = true
        mailLabel.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, constant: -40).isActive = true
    }
    
    private func addConstrainsts() {
        setBackButtonConstraints()
        setImageViewConstraints()
        seNameLabelConstraints()
        setStatusLabelConstraints()
        setMailLabelConstraints()
    }
    
    private func activateCenterConstraints() {
        if traitCollection.horizontalSizeClass == .regular {
            NSLayoutConstraint.deactivate(centerConstraints.0)
            NSLayoutConstraint.activate(centerConstraints.1)
        } else {
            NSLayoutConstraint.deactivate(centerConstraints.1)
            NSLayoutConstraint.activate(centerConstraints.0)
        }
    }
    
    //MARK: - targets
    @objc private func backButtonTapped() {
        self.dismiss(animated: true)
    }
}

extension DetailViewController: ZoomViewController {
    func zoomingImageView(for transition: ZoomTransitionDelegate) -> UIImageView? {
        return imageView
    }
    
    func zoomingIsOnlineView(for transition: ZoomTransitionDelegate) -> UIView? {
        return statusLabel
    }
    
    func zoomingEmailView(for transition: ZoomTransitionDelegate) -> UIView? {
        return mailLabel
    }
    
    func zoomingNameView(for transition: ZoomTransitionDelegate) -> UIView? {
        return nameLabel
    }
    
    func zoomingBackButton(for transition: ZoomTransitionDelegate) -> UIView? {
        return backButton
    }
    
    
}
