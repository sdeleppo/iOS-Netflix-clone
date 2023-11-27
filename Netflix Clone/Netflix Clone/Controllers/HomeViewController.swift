//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Sarah Deleppo on 12/27/22.

import UIKit

class HomeViewController: UIViewController {
    let sectionTitles: [String] = ["Trending Movies", "Popular", "Trending TV", "Top Rated", "Upcoming Movies"]
    
    var lastOffset:CGFloat = 0
    var offset:CGFloat = 0
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped);
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavbar()
        
        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 530))
        homeFeedTable.tableHeaderView = headerView
    }
    
    private func configureNavbar() {
        var image = UIImage(named: "netflixLogo")
        
        //UIImage(systemName: "person")
        //UIImage(named: "netflixLogo")
        
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    
    
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.lowercased()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if ((self.lastOffset < scrollView.contentOffset.y) && scrollView.contentOffset.y >= 5) {
            if (self.offset < 100 && self.offset >= 0) {
                self.offset += 10
            }
            navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -self.offset))
        } else if ((self.lastOffset > scrollView.contentOffset.y) && scrollView.contentOffset.y != 0) {
            if (self.offset <= 100 && self.offset > 0) {
                self.offset -= 10
            }
            navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -self.offset))
        }
        self.lastOffset = scrollView.contentOffset.y
    }
}
