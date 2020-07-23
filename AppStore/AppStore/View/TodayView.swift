import SwiftUI
import UIKit
struct TodayView: View {
    @State var cards : [Card] = Card.all()
    @ObservedObject var getDate = GetDate()
    let geometry = UIScreen.main.bounds
    let bottomPadding : CGFloat = 20
    @State var isBig = false
    @ViewBuilder var body: some View {
        ScrollView(.vertical,showsIndicators: false){
            VStack{
                HStack(){
                    VStack(alignment: .leading){
                        Text(self.getDate.today).foregroundColor(.secondary).font(.system(size: 20))
                        Text("Today").foregroundColor(.init(.label)).font(.system(size: 25, weight: .bold))
                    }
                    Spacer()
                }.padding(.horizontal).padding(.top,15)
                ForEach(0..<cards.count,id: \.self){i in
                    GeometryReader{g in
                        CardView(card: self.$cards[i],isBig: self.$isBig)
                            .offset(y: self.cards[i].expand ? -g.frame(in: .global).minY : 0)
                    }.frame(width: self.cards[i].expand ? self.geometry.width : self.geometry.width * 0.88,height: self.cards[i].expand ? UIScreen.main.bounds.height : UIScreen.main.bounds.height * 0.4 ).padding(.bottom,self.bottomPadding)
                }
            }
        }


    }
}
struct TouchesHandler: UIViewRepresentable {

    var didBeginTouch: (()->Void)?
    var didEndTouch: (()->Void)?

    func makeUIView(context: UIViewRepresentableContext<TouchesHandler>) -> UIView {
        let view = UIView(frame: .zero)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(context.coordinator.makeGesture(didBegin: didBeginTouch, didEnd: didEndTouch))
        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<TouchesHandler>) {
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    class Coordinator {
        @objc
        func action(_ sender: Any?) {
            print("Tapped!")
        }

        func makeGesture(didBegin: (()->Void)?, didEnd: (()->Void)?) -> MyTapGesture {
            MyTapGesture(target: self, action: #selector(self.action(_:)), didBeginTouch: didBegin, didEndTouch: didEnd)
        }
    }
    typealias UIViewType = UIView
}
class MyTapGesture : UITapGestureRecognizer {

    var didBeginTouch: (()->Void)?
    var didEndTouch: (()->Void)?

    init(target: Any?, action: Selector?, didBeginTouch: (()->Void)? = nil, didEndTouch: (()->Void)? = nil) {
        super.init(target: target, action: action)
        self.didBeginTouch = didBeginTouch
        self.didEndTouch = didEndTouch
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        self.didBeginTouch?()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        self.didEndTouch?()
    }
}

struct CardView:View{
    @State var width : CGFloat = UIScreen.main.bounds.width * 0.88
    @State var height : CGFloat =  UIScreen.main.bounds.height * 0.4
    @Binding var card:Card
    @State var doScale = false
    @Binding var isBig:Bool
    @ViewBuilder var body: some View{
        VStack{
            Image(self.card.imageUrl)
                .resizable()
                .frame(width: self.card.expand ? UIScreen.main.bounds.width : self.width,height: self.height)
                .cornerRadius(self.card.expand ? 0 : 8)
                .onDisappear{
                        if self.card.expand{
                            self.isBig.toggle()
                            self.card.expand.toggle()
                        }
                }
                .overlay(TouchesHandler(didBeginTouch: {
                if !self.card.expand{
                    withAnimation(.spring()){
                        self.doScale = true
                    }
                }
                }, didEndTouch: {
                    if !self.card.expand{
                        withAnimation(.spring()){
                            self.doScale = false
                        }
                    }
                })).scaleEffect(self.card.expand ? 1 : (self.doScale ? 0.95 : 1))
                .onTapGesture {
                    if !self.card.expand{
                        withAnimation(.spring()){
                            self.card.expand.toggle()
                            self.isBig.toggle()
                        }
                    }else if self.card.expand{
                        withAnimation(.spring()){
                            self.card.expand.toggle()
                            self.isBig.toggle()
                        }
                    }
            }
            if isBig{
                ScrollView(.vertical,showsIndicators: false){
                    VStack{
                        HStack{
                            Text(card.title).foregroundColor(.secondary).font(.system(size: 20)).padding(.horizontal)
                            Spacer()
                        }
                        HStack{
                            Text(card.content).foregroundColor(.init(.label)).font(.system(size: 25, weight: .bold)).padding(.horizontal)
                            Spacer()
                        }
                        HStack{
                            Text(card.bottomText).foregroundColor(.secondary).font(.system(size: 18)).lineLimit(nil).fixedSize(horizontal: false, vertical: true).padding(.horizontal)
                            Spacer()
                        }
                        Text(card.detail).lineLimit(nil).padding().padding(.bottom,50)
                        Spacer()
                    }
                }



            }

            }.shadow(radius: 5).opacity(self.isBig ? (self.card.expand ? 1 : 0) : 1)

    }
}


struct DetailCardView: View {
    let title:String
    let content:String
    let bottomText:String
    var body: some View{
        ZStack{
            Color.init(.systemBackground)
            HStack{
                VStack(alignment: .leading){
                    Text(self.title).foregroundColor(.secondary).font(.system(size: 20))
                    Text(self.content).foregroundColor(.init(.label)).font(.system(size: 25, weight: .bold))
                    Text(self.bottomText).foregroundColor(.secondary).font(.system(size: 16)).lineLimit(1)
                    Spacer()
                }.padding(.horizontal)
                Spacer()
            }
        }.frame(width: UIScreen.main.bounds.width * 0.88, height: 100)
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
