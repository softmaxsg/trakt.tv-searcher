//
//  MoviesTableViewDataSource.swift
//  TraktSearcher
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import UIKit

class MoviesTableViewDataSource: NSObject, UITableViewDataSource
{
    private(set) var viewModel: MoviesViewModelData?

    init(viewModel: MoviesViewModelData)
    {
        self.viewModel = viewModel
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.viewModel?.movies.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(MovieTableViewCell), forIndexPath: indexPath) as! MovieTableViewCell

        guard let movies = self.viewModel?.movies else {
            assert(false)
            return cell
        }

        assert(indexPath.section == 0)
        assert(indexPath.item < movies.count)

        cell.update(movies[indexPath.item])

        return cell
    }
}
