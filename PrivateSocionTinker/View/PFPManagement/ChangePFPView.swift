import SwiftUI
   
   struct ChangePFPView: View {
       
       @State private var isShowingPhotoSelectionSheet = false

       @State private var finalImage: UIImage?
       @State private var inputImage: UIImage?
       @EnvironmentObject var userViewModel : UserViewModel
       
       var body: some View {
           
           VStack {
               
               if finalImage != nil {
                   Image(uiImage: finalImage!)
                       .resizable()
                       .frame(width: 100, height: 100)
                       .scaledToFill()
                       .aspectRatio(contentMode: .fit)
                       .clipShape(Circle())
                       .shadow(radius: 4)
               } else {
                   Image(systemName: "person.crop.circle.fill")
                       .resizable()
                       .scaledToFill()
                       .frame(width: 100, height: 100)
                       .aspectRatio(contentMode: .fit)
                       .foregroundColor(.systemGray2)
               }
               Button (action: {
                   self.isShowingPhotoSelectionSheet = true
               }, label: {
                   Text("Change photo")
                       .foregroundColor(.systemRed)
                       .font(.footnote)
               })
           }
           .background(Color.systemBackground)
           .statusBar(hidden: isShowingPhotoSelectionSheet)
           .fullScreenCover(isPresented: $isShowingPhotoSelectionSheet, onDismiss: loadImage) {
               ImageMoveAndScaleSheet(croppedImage: $inputImage)
           }
       }
       
       func loadImage() {
           print("Outer Calling")
           guard let inputImage = inputImage else { return }
           finalImage = inputImage
           if finalImage != nil {
               let size = finalImage!.getSizeInMB()
               if  size > 200 || size == 0 {
                   print("Image Too Big")
               }
               print("Calling")
               userViewModel.updateProfilePic(image: finalImage!)
           }
       }
   }
   
