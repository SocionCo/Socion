//
//import Foundation
//import SwiftUI
//
//struct ViewTest : View {
//    
//    @State var searchText : String = ""
//    let campaigns : [Contract] = [Contract(id: UUID().uuidString, company: "New Company", status: Contract.Progress.inProgress, influencer: "Temp Influencer", paymentStatus: Contract.Progress.inProgress, postLink: nil, dueDate: Date(timeIntervalSince1970: 0), rate: 500.0, tasks: [], isCompletedArray: [], influencerAssignedToContract: nil, miscellaneous: "sagds", notes: "sagsadf"),Contract(id: UUID().uuidString, company: "New Company", status: Contract.Progress.inProgress, influencer: "Temp Influencer", paymentStatus: Contract.Progress.inProgress, postLink: nil, dueDate: Date(timeIntervalSince1970: 0), rate: 500.0, tasks: [], isCompletedArray: [], influencerAssignedToContract: nil, miscellaneous: "sagds", notes: "sagsadf"),Contract(id: UUID().uuidString, company: "New Company", status: Contract.Progress.inProgress, influencer: "Temp Influencer", paymentStatus: Contract.Progress.inProgress, postLink: nil, dueDate: Date(timeIntervalSince1970: 0), rate: 500.0, tasks: [], isCompletedArray: [], influencerAssignedToContract: nil, miscellaneous: "sagds", notes: "sagsadf")]
//    
//    var body : some View {
//        NavigationStack {
//            VStack (alignment: .center, spacing: 0) {
//                Group {
//                    Text(userViewModel.getName())
//                        .foregroundColor(.white)
//                        .frame(width: 700, height: 80)
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                        .minimumScaleFactor(0.5)
//                    
//                    SearchBar(text: $searchText)
//                }
//                .padding()
//                .background(.green)
//                
//                
//                List() {
//                    ForEach (userViewModel.user.contracts.sorted(by: sorterForDates), id: \.self) { campaign in
//                        NavigationLink {
//                            ContractDetailView(contractID: campaign.id)
//                        } label: {
//                            VStack(alignment: .leading, spacing: 5) {
//                                Text(campaign.name)
//                                    .font(.title3)
//                                    .lineLimit(1)
//                                    .bold()
//                                    .padding(.bottom, 5.0)
//                                HStack (spacing: 10) {
//                                    Text("Campaign Status")
//                                        .foregroundColor(.gray)
//                                        .bold()
//                                        .listRowSeparator(.hidden)
//                                    Text(campaign.status.rawValue)
//                                        .foregroundColor(.white)
//                                        .fontWeight(.bold)
//                                        .frame(width: 110, height: 25)
//                                        .background(Contract.statusColor(contract: campaign))
//                                        .cornerRadius(20)
//                                }
//                                HStack (spacing: 20) {
//                                    Text("Payment Status:")
//                                        .listRowSeparator(.hidden)
//                                        .foregroundColor(.gray)
//                                        .bold()
//                                    Text(campaign.paymentStatus.rawValue)
//                                        .foregroundColor(.white)
//                                        .fontWeight(.bold)
//                                        .frame(width: 110, height: 25)
//                                        .background(Contract.statusColor(contract: campaign))
//                                        .cornerRadius(20)
//                                }
//                            }
//                        }.listRowBackground (
//                            RoundedRectangle(cornerRadius: 17)
//                                .fill(Color.white)
//                                .padding(2))
//                    }
//                }.listStyle(.automatic)
//            }
//        }
//    }
//}
//
//
//import SwiftUI
//
//struct ContentView: View {
//    @State private var someList = [0, 1, 2, 3, 4]
//    
//    var body: some View {
//        List {
//            ForEach(someList, id: \.self) { n in
//                Text("\(n)")
//                    .foregroundColor(.white)
//                    .listRowBackground(
//                        RoundedRectangle(cornerRadius: 5)
//                            .background(.clear)
//                            .foregroundColor(.blue)
//                            .padding(
//                                EdgeInsets(
//                                    top: 2,
//                                    leading: 10,
//                                    bottom: 2,
//                                    trailing: 10
//                                )
//                            )
//                    )
//                    .listRowSeparator(.hidden)
//            }
//            .onDelete { idx in
//                someList.remove(atOffsets: idx)
//            }
//        }
//        .listStyle(.plain)
//    }
//}
