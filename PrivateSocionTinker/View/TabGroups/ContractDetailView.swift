import SwiftUI

struct ContractDetailView: View {
    let contract: Contract
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                Text("Contract Details")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                
                individualItem(title: "Company Name:", content: contract.company)
                individualItem(title: "Influencer Name:", content: contract.name)
                individualItem(title: "Progress:", content: contract.status.rawValue)
                if (contract.dueDate != nil) {
                    individualItem(title: "Due Date:", content: Contract.dateToStringForPresentation(date: contract.dueDate)!)
                    individualItem(title: "Due In:", content: Contract.timeUntilDate(date: contract.dueDate)!)
                }
                if (contract.rate != nil && contract.rate != 0) {
                    individualItem(title: "Payment Amount:", content: String(contract.rate!))
                }
                if (contract.postLink != nil && contract.postLink != "") {
                    HStack {
                        Text("Post Link:")
                            .font(.title3)
                            .fontWeight(.bold)
                        Text("[link](contract.postLink)")
                            .font(.title3)
                    }
                }
                
                
                
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward").foregroundColor(.white)
                    }
                }
            }.navigationBarBackButtonHidden(true)
            .padding()
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.green, Color.white]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
            )
        }
    }

struct individualItem : View {
    @State var title : String
    @State var content : String
    var body : some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
            Text(content)
                .font(.title3)
        }
    }
}


struct ContractDetailViewPreview : PreviewProvider {
    static var previews: some View {
        ContractDetailView(contract: (Contract(id: "sadf", company: "asfd", status: Contract.Progress.inProgress, influencer: "asfd", paymentStatus: Contract.Progress.inProgress, postLink: nil, dueDate: nil, rate: nil)))
    }
}

