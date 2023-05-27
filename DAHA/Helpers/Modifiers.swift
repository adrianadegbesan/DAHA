//
//  Modifiers.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/4/23.
//

import Foundation
import SwiftUI
import Combine
import UIKit


extension Bool {
     static var iOS16: Bool {
         guard #available(iOS 16, *) else {
             return false
         }
         return true
     }
 }

extension Binding {
    func onUpdate(_ closure: @escaping () -> Void) -> Binding<Value> {
        Binding(get: {
            wrappedValue
        }, set: { newValue in
            wrappedValue = newValue
            closure()
        })
    }
}

extension Publishers {
    // 1.
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        // 2.
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        // 3.
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

extension UIResponder {
    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return _currentFirstResponder
    }

    private static weak var _currentFirstResponder: UIResponder?

    @objc private func findFirstResponder(_ sender: Any) {
        UIResponder._currentFirstResponder = self
    }

    var globalFrame: CGRect? {
        guard let view = self as? UIView else { return nil }
        return view.superview?.convert(view.frame, to: nil)
    }
}

struct KeyboardAdaptive: ViewModifier {
    @State private var bottomPadding: CGFloat = 0
    @State private var scale = 1.0
    
    func body(content: Content) -> some View {
        // 1.
        GeometryReader { geometry in
            content
                .padding(.bottom, self.bottomPadding)
                // 2.
                .onReceive(Publishers.keyboardHeight) { keyboardHeight in
                    // 3.
                    let keyboardTop = geometry.frame(in: .global).height - keyboardHeight
                    // 4.
                    let focusedTextInputBottom = UIResponder.currentFirstResponder?.globalFrame?.maxY ?? 0
                    // 5.
                    self.bottomPadding = max(0, focusedTextInputBottom - keyboardTop - geometry.safeAreaInsets.bottom)
            }
            // 6.
            .animation(.easeOut(duration: 0.15), value: scale)
            
        }
    }
}

extension View {
    func keyboardAdaptive() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAdaptive())
    }
    
    func hideNavigationBar(value: Binding<Bool>) -> some View {
        self
            .navigationBarTitle("")
            .navigationBarHidden(value.wrappedValue)
            .onAppear{
                value.wrappedValue = true
            }
    }
}


//extension UINavigationController: UIGestureRecognizerDelegate {
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//        interactivePopGestureRecognizer?.delegate = self
//    }
//
//    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return viewControllers.count > 1
//    }
//}

struct DismissKeyboardOnDrag: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(GestureOverlay())
    }

    private struct GestureOverlay: UIViewRepresentable {
        func makeUIView(context: Context) -> UIView {
            let view = UIView(frame: .zero)
            view.backgroundColor = UIColor.clear

            let recognizer = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleGesture(_:)))
            view.addGestureRecognizer(recognizer)

            return view
        }

        func updateUIView(_ uiView: UIView, context: Context) {}

        func makeCoordinator() -> Coordinator {
            Coordinator()
        }

        class Coordinator: NSObject {
            @objc func handleGesture(_ gesture: UIPanGestureRecognizer) {
                if gesture.state == .began || gesture.state == .changed {
                    let translation = gesture.translation(in: nil)
                    if translation.y > 0 {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
            }
        }
    }
}

extension View {
    func dismissKeyboardOnDrag() -> some View {
        self.modifier(DismissKeyboardOnDrag())
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    func dismissKeyboard() {
         sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ButtonPress: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        onPress()
                    })
                    .onEnded({ _ in
                        onRelease()
                    })
            )
    }
}

extension View {
    func pressEvents(onPress: @escaping (() -> Void), onRelease: @escaping (() -> Void)) -> some View {
        modifier(ButtonPress(onPress: {
            onPress()
        }, onRelease: {
            onRelease()
        }))
    }
}

struct shimmerOnTap: ViewModifier {
    @State private var shimmer: Bool = false

    func body(content: Content) -> some View {
        content
            .shimmering(
                active: shimmer,
                animation: .easeIn(duration: 0.7)
            )
            .onTapGesture {
                withAnimation{
                    shimmer = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9){
                    withAnimation {
                        shimmer = false
                    }
                }
            }
    }
}
