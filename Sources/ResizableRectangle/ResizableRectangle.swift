//
//  SwiftUIView.swift
//
//
//  Created by Shibo Tong on 11/8/2023.
//

import SwiftUI

public struct ResizableRectangle: View {
    @Binding public var rect: CGRect
    
    @State private var previousRect: CGRect?
    
    private let maxRect: CGSize?
    
    public init(rect: Binding<CGRect>, max: CGSize? = nil) {
        _rect = rect
        maxRect = max
    }
    
    private let size: CGFloat = 5
    
    enum Position {
        case top, left, bottom, right
    }
    
    public var body: some View {
        ZStack {
            Rectangle()
                .frame(width: rect.width, height: rect.height)
                .offset(x: rect.origin.x, y: rect.origin.y)
                .opacity(0.2)
            Group {
                makeSide(position: .top)
                makeSide(position: .bottom)
                makeSide(position: .left)
                makeSide(position: .right)
            }
            Group {
                makeCircle(positions: [.top, .left])
                makeCircle(positions: [.top, .right])
                makeCircle(positions: [.bottom, .left])
                makeCircle(positions: [.bottom, .right])
                makeCircle(positions: [.top])
                makeCircle(positions: [.left])
                makeCircle(positions: [.right])
                makeCircle(positions: [.bottom])
            }
        }
    }
    
    @ViewBuilder
    private func makeSide(position: Position) -> some View {
        Rectangle()
            .fill(Color.red)
            .frame(width: sideWidth(position: position), height: sideHeight(position: position))
            .offset(sideOffSet(positions: [position]))
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        moving(value: value, positions: [position])
                    })
                    .onEnded({ _ in
                        previousRect = rect
                    })
            )
    }
    
    @ViewBuilder
    private func makeCircle(positions: [Position]) -> some View {
        Circle()
            .fill(Color.green)
            .frame(width: size + 3, height: size + 3)
            .offset(sideOffSet(positions: positions))
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        moving(value: value, positions: positions)
                    })
                    .onEnded({ _ in
                        previousRect = rect
                    })
            )
    }
    
    private func sideWidth(position: Position) -> CGFloat {
        switch position {
        case .top, .bottom:
            return rect.width
        case .left, .right:
            return size
        }
    }
    
    private func sideHeight(position: Position) -> CGFloat {
        switch position {
        case .top, .bottom:
            return size
        case .left, .right:
            return rect.height
        }
    }
    
    private func sideOffSet(positions: [Position]) -> CGSize {
        var width = rect.origin.x
        var height = rect.origin.y
        for position in positions {
            switch position {
            case .top:
                height -= rect.height / 2
            case .bottom:
                height += rect.height / 2
            case .left:
                width -= rect.width / 2
            case .right:
                width += rect.width / 2
            }
        }
        return CGSize(width: width, height: height)
    }
    
    private func moving(value: DragGesture.Value, positions: [Position]) {
        if previousRect == nil {
            previousRect = rect
        }
        guard let previousRect else {
            return
        }
        for position in positions {
            switch position {
            case .top:
                rect.size.height = previousRect.height - value.translation.height
                rect.origin.y = previousRect.origin.y + value.translation.height / 2
                if !canMove() {
                    guard let maxRect else {
                        continue
                    }
                    rect.size.height = maxRect.height / 2 + sideOffSet(positions: [.bottom]).height
                    rect.origin.y = -(maxRect.height - rect.size.height) / 2
                }
            case .bottom:
                rect.size.height = previousRect.height + value.translation.height
                rect.origin.y = previousRect.origin.y + value.translation.height / 2
                if !canMove() {
                    guard let maxRect else {
                        continue
                    }
                    rect.size.height = maxRect.height / 2 - sideOffSet(positions: [.top]).height
                    rect.origin.y = (maxRect.height - rect.size.height) / 2
                }
            case .left:
                rect.size.width = previousRect.width - value.translation.width
                rect.origin.x = previousRect.origin.x + value.translation.width / 2
                if !canMove() {
                    guard let maxRect else {
                        continue
                    }
                    rect.size.width = maxRect.width / 2 + sideOffSet(positions: [.right]).width
                    rect.origin.x = -(maxRect.width - rect.size.width) / 2
                }
            case .right:
                rect.size.width = previousRect.width + value.translation.width
                rect.origin.x = previousRect.origin.x + value.translation.width / 2
                if !canMove() {
                    guard let maxRect else {
                        continue
                    }
                    rect.size.width = maxRect.width / 2 - sideOffSet(positions: [.left]).width
                    rect.origin.x = (maxRect.width - rect.size.width) / 2
                }
            }
        }
    }
    
    private func canMove() -> Bool {
        guard let maxRect else {
            return true
        }
        
        let topOffset = sideOffSet(positions: [.top])
        let leftOffset = sideOffSet(positions: [.left])
        let rightOffset = sideOffSet(positions: [.right])
        let bottomOffset = sideOffSet(positions: [.bottom])
        
        guard topOffset.height < bottomOffset.height else {
            return false
        }
        guard leftOffset.width < rightOffset.width else {
            return false
        }
        
        guard topOffset.height <= maxRect.height / 2 else {
            return false
        }
        guard topOffset.height >= -maxRect.height / 2 else {
            return false
        }
        guard bottomOffset.height <= maxRect.height / 2 else {
            return false
        }
        guard bottomOffset.height >= -maxRect.height / 2 else {
            return false
        }
        guard leftOffset.width <= maxRect.width / 2 else {
            return false
        }
        guard leftOffset.width >= -maxRect.width / 2 else {
            return false
        }
        guard rightOffset.width <= maxRect.width / 2 else {
            return false
        }
        guard rightOffset.width >= -maxRect.width / 2 else {
            return false
        }
        return true
    }
}

struct ResiableRectangle_Previews: PreviewProvider {
    
    @State static var rect: CGRect = CGRect(x: 0, y: 0, width: 200, height: 100)
    
    static var previews: some View {
        ResizableRectangle(rect: $rect)
    }
}
