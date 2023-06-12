//
//  ImagePreview.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/2/23.
//

import SwiftUI
import TOCropViewController

struct ImagePreview: View {
    
    @State var image: UIImage?
    @State var newImage: UIImage?
    @Binding var images: [UIImage]
    @State private var showingCropView: Bool = false
    @Environment(\.presentationMode) private var presentationMode

//    @State var index: Int
    
    var body: some View {
        if image != nil{
            ZStack(alignment: .topLeading){
                
                ZStack(alignment: .topTrailing){
                    Image(uiImage: image!)
                        .resizable()
                        .cornerRadius(15)
                        .clipped()
                        .scaledToFit()
                        .overlay (
                           RoundedRectangle(cornerRadius: 15)
                            .strokeBorder(lineWidth: 3)
                        )
                        .scaleEffect(0.93)
                    
                    Image(systemName: "pencil")
                        .font(.system(size: 14))
                        .padding(5)
                        .background(Circle().fill(.white))
                        .overlay(Circle().stroke(lineWidth: 2))
                        .foregroundColor(Color(hex: deepBlue))
                        .onTapGesture {
                            SoftFeedback()
                            showingCropView = true
                        }
                        .offset(x: -1, y: 1.5)
                }
                

                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 20))
                        .background(Circle().fill(.white))
                        .onTapGesture {
                            SoftFeedback()
                            let index = images.firstIndex(of: image!)
                            print(image!)
                            if index != nil{
                            print(index!)
                            images.remove(at: index!)
                            }
                        }
                        .offset(x: 1, y: 1.5)
                
                
            
                
            }
            .sheet(isPresented: $showingCropView){
                CropView(oldImage: $image, newImage: $newImage, images: $images, isPresented: $showingCropView)
            }
        }
    }
}

struct ImagePreview_Previews: PreviewProvider {
    static var previews: some View {
        let images: [UIImage] = []
        ImagePreview(image: nil, images: .constant(images))
    }
}


struct CropView: UIViewControllerRepresentable {
    typealias UIViewControllerType = TOCropViewController
    
    @Binding var oldImage: UIImage?
    @Binding var newImage: UIImage?
    @Binding var images: [UIImage]
    @Binding var isPresented: Bool
    @Environment(\.presentationMode) private var presentationMode

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> TOCropViewController {
        let cropViewController = TOCropViewController(croppingStyle: .default, image: oldImage!)
        cropViewController.delegate = context.coordinator
        return cropViewController
    }

    func updateUIViewController(_ uiViewController: TOCropViewController, context: Context) {
    }

    class Coordinator: NSObject, TOCropViewControllerDelegate {
        var parent: CropView

        init(_ parent: CropView) {
            self.parent = parent
        }

        func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with rect: CGRect, angle: Int) {
            
            cropViewController.dismiss(animated: true) {
                self.parent.newImage = image
                
                if self.parent.oldImage != nil {
                    let index = self.parent.images.firstIndex(of: self.parent.oldImage!)
                    if index != nil {
                        if self.parent.newImage != nil {
                            self.parent.images[index!] = self.parent.newImage!
                            self.parent.oldImage = self.parent.newImage!
                        }
                    }
                }
            }
            
        }
    }
}
