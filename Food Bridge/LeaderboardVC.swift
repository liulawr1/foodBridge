//
//  LeaderboardVC.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 12/30/24.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

class LeaderboardVC: UIViewController {
    
    // MARK: - Properties
    
    struct LeaderboardEntry {
        let email: String
        let totalListings: Int
    }
    
    let header_lb: UILabel = {
        let lb = UILabel()
        lb.text = "Leaderboard"
        lb.font = UIFont.boldSystemFont(ofSize: 45)
        lb.textColor = forestGreen
        lb.textAlignment = .center
        return lb
    }()
    
    let tableView = UITableView()
    var leaderboardData: [LeaderboardEntry] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = lightGreen
        setup_UI()
        setupRefreshControl()
        fetchLeaderboard()
    }
    
    // MARK: - Firestore Fetch
    
    private func fetchLeaderboard() {
        // Query the 'users' collection, order by total_listings desc, limit to top 10
        db.collection("users")
            .order(by: "total_listings", descending: true)
            .limit(to: 10)
            .getDocuments { (querySnapshot, err) in
                
                // End refreshing if in progress
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                }
                
                if let err = err {
                    print("Error getting documents: \(err)")
                    return
                }
                
                guard let docs = querySnapshot?.documents else { return }
                
                // Build an array of LeaderboardEntry
                var tempData: [LeaderboardEntry] = []
                for doc in docs {
                    let email = doc.data()["email"] as? String ?? "No Email"
                    let total = doc.data()["total_listings"] as? Int ?? 0
                    
                    let entry = LeaderboardEntry(email: email, totalListings: total)
                    tempData.append(entry)
                }
                
                // Firestore already returns in desc order, but if needed you can re-sort:
                // tempData.sort { $0.totalListings > $1.totalListings }
                
                self.leaderboardData = tempData
                
                // Reload the table on the main thread
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
        }
    }
    
    // MARK: - Refresh Control
    
    private func setupRefreshControl() {
        // Create the UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = forestGreen
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        // Attach it to the tableView
        tableView.refreshControl = refreshControl
    }
    
    @objc private func handleRefresh() {
        print("refreshing...")
        fetchLeaderboard()
    }
    
    // MARK: - UI Setup
    
    func setup_UI() {
        let top_margin: CGFloat = 100
        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        
        // Header label
        header_lb.frame = CGRect(x: left_margin, y: top_margin, width: elem_w, height: elem_h)
        view.addSubview(header_lb)
        
        // TableView (below the header)
        let tableY = header_lb.frame.maxY + elem_margin + 20
        let tableH = view.frame.height - tableY - 20
        tableView.frame = CGRect(x: left_margin, y: tableY, width: elem_w, height: tableH)
        tableView.backgroundColor = lightGreen
        
        // Register a basic cell & set dataSource/delegate
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension LeaderboardVC: UITableViewDataSource, UITableViewDelegate {
    // Number of rows equals number of leaderboard entries
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboardData.count
    }
    
    // Configure each cell to show rank, user email, and total listings
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = lightGreen
        
        let entry = leaderboardData[indexPath.row]
        let rank = indexPath.row + 1   // 1-based rank
        
        cell.textLabel?.text = "\(rank). \(entry.email) - \(entry.totalListings)"
        cell.textLabel?.textColor = forestGreen
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        return cell
    }
    
    // Optional: row selection, if you want more details
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // e.g. navigate to detail page
    }
}
