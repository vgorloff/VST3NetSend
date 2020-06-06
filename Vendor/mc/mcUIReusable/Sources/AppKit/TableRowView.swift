//
//  TableRowView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 21.09.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import Foundation

public class TableRowView: NSTableRowView {

   public var separatorHeight: CGFloat = 1 {
      didSet {
         needsDisplay = true
      }
   }

   public var separatorColor: NSColor = .gridColor {
      didSet {
         needsDisplay = true
      }
   }

   public var selectionColor: NSColor = NSColor.alternateSelectedControlColor {
      didSet {
         needsDisplay = true
      }
   }

   public override var isSelected: Bool {
      didSet {
         (0 ..< numberOfColumns).compactMap { view(atColumn: $0) as? TableRowItemView }.forEach { $0.setSelected(isSelected) }
      }
   }

   public override init(frame frameRect: NSRect) {
      super.init(frame: frameRect)
      separatorHeight = convertFromBacking(1)
   }

   required init?(coder decoder: NSCoder) {
      fatalError()
   }

   public override func drawSelection(in dirtyRect: NSRect) {
      let rect = bounds.insetBottom(by: -separatorHeight)
      selectionColor.setFill()
      rect.fill()
   }

   public override func drawSeparator(in dirtyRect: NSRect) {
      let rect = bounds.insetTop(by: bounds.height - separatorHeight)
      separatorColor.setFill()
      rect.fill()
   }
}
#endif
