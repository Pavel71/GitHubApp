//
//  Animator.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 15.09.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//
import UIKit


typealias Animation = (UITableViewCell, IndexPath, UITableView) -> Void


enum AnimationFactory {

    static func makeFadeAnimation(duration: TimeInterval, delayFactor: Double) -> Animation {
        return { cell, indexPath, _ in
            cell.alpha = 0

            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                animations: {
                    cell.alpha = 1
            })
        }
    }
  
  static func makeMoveUpWithBounce(rowHeight: CGFloat, duration: TimeInterval, delayFactor: Double) -> Animation {
    
      return { cell, indexPath, tableView in
          cell.transform = CGAffineTransform(translationX: 0, y: rowHeight)

          UIView.animate(
              withDuration: duration,
              delay: delayFactor * Double(indexPath.row),
              usingSpringWithDamping: 0.4,
              initialSpringVelocity: 0.1,
              options: [.curveEaseInOut],
              animations: {
                  cell.transform = CGAffineTransform(translationX: 0, y: 0)
          })
      }
  }
  
  static func makeMoveUpWithFade(rowHeight: CGFloat, duration: TimeInterval, delayFactor: Double) -> Animation {
      return { cell, indexPath, _ in
          cell.transform = CGAffineTransform(translationX: 0, y: rowHeight / 2)
          cell.alpha = 0

          UIView.animate(
              withDuration: duration,
              delay: delayFactor * Double(indexPath.row),
              options: [.curveEaseInOut],
              animations: {
                  cell.transform = CGAffineTransform(translationX: 0, y: 0)
                  cell.alpha = 1
          })
      }
  }
  
  static func makeSlideIn(duration: TimeInterval, delayFactor: Double) -> Animation {
      return { cell, indexPath, tableView in
          cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)

          UIView.animate(
              withDuration: duration,
              delay: delayFactor * Double(indexPath.row),
              options: [.curveEaseInOut],
              animations: {
                  cell.transform = CGAffineTransform(translationX: 0, y: 0)
          })
      }
  }
}


final class Animator {
    private var hasAnimatedAllCells = false
    private let animation: Animation

    init(animation: @escaping Animation) {
        self.animation = animation
    }

    func animate(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
        guard !hasAnimatedAllCells else {
            return
        }

        animation(cell, indexPath, tableView)

//        hasAnimatedAllCells = tableView.isLastVisibleCell(at: indexPath)
    }
}
