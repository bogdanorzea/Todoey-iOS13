//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Bogdan Orzea on 1/30/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = 80.0
        self.tableView.separatorStyle = .none
    }

    // MARK: - TableView data source methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self

        return cell
    }

    // MARK: - SwipeCell delegate methods

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.delete(at: indexPath)
        }

        // customize the action appearance
        deleteAction.image = UIImage(systemName: "trash.fill")

        return [deleteAction]
    }

    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .drag
        return options
    }

    func delete(at indexPath: IndexPath) {
        fatalError("Must override method in sub-class")
    }
}

extension UIViewController {
    func configureNavigationBar(largeTitleColor: UIColor, backgroundColor: UIColor, tintColor: UIColor, title: String? = nil) {
        guard let navigationBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist")
        }

        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
            navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColor]
            navBarAppearance.backgroundColor = backgroundColor

            navigationBar.standardAppearance = navBarAppearance
            navigationBar.compactAppearance = navBarAppearance
            navigationBar.scrollEdgeAppearance = navBarAppearance

            navigationBar.isTranslucent = false
            navigationBar.tintColor = tintColor
        } else {
            // Fallback on earlier versions
            navigationBar.barTintColor = backgroundColor
            navigationBar.tintColor = tintColor
            navigationBar.isTranslucent = false
        }

        if title != nil {
            navigationItem.title = title
        }
    }
}
