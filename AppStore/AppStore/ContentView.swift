import SwiftUI
import Pages
struct ContentView: View {
    let sections = Bundle.main.decode([Section].self, from: "appstore.json")
    var featuredApps : [App] = []
    var mediumTableApps : [App] = []
    var smallTableApps : [App] =  []
    init() {
        for app in sections{
            if app.type == "featured"{
                featuredApps = app.items
            }else if app.type == "mediumTable"{
                mediumTableApps = app.items
            }else if app.type == "smallTable"{
                smallTableApps = app.items
            }
        }
    }
    var body: some View {
        NavigationView{
            ScrollView(.vertical,showsIndicators: false){
                VStack(){
                    Divider()
                    FeaturedScrollView(apps: featuredApps).frame(width: UIScreen.main.bounds.width, height: 350)
                    Divider()
                    MediumTableView(apps: mediumTableApps,title: "This Week's Favorites").frame(width: UIScreen.main.bounds.width, height: 250)
                    Divider()
                    MediumTableView(apps: mediumTableApps,title: "Top Paid Apps").frame(width: UIScreen.main.bounds.width, height: 250)
                    Divider()
                    SmallTableView(smallTableApps: smallTableApps)
                    Divider()
                    FeaturedScrollView(apps: featuredApps,title: "Special Events").frame(width: UIScreen.main.bounds.width, height: 350)

                }
            }
            .navigationBarTitle(Text("Apps"))
        }



    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ContentView()
        }
    }
}

struct FeaturedScrollView:View{
    init(apps: [App],title:String? = nil) {
        self.featuredApps = apps
        if let titleString = title {
            self.title = titleString
        }
    }
    var title:String = ""
    @State var index: Int = 0
    var featuredApps : [App]
    var body:some View{
        VStack(alignment: .leading){
            if self.title != ""{
                Text(self.title).padding(.horizontal).font(.system(size: 26, weight: .bold))
            }
        ModelPages(featuredApps,currentPage: $index,navigationOrientation: .horizontal,hasControl: false){pageIndex, app in
            VStack(alignment: .leading,spacing: 10){
                Text(app.tagline.uppercased()).foregroundColor(.blue).bold().padding(.horizontal)
                Text(app.name).foregroundColor(.secondary).font(.headline).padding(.horizontal)
                Text(app.subheading).padding(.horizontal)
                Image(app.image).resizable().renderingMode(.original).cornerRadius(8).frame(width: UIScreen.main.bounds.width * 0.93,height: 250).padding(.horizontal)
            }

        }
    }
    }
}
struct MediumTableView:View{
    init(apps: [App],title:String) {
        self.mediumApps = apps
        self.title = title
    }
    var title: String
    @State var index: Int = 0
    var mediumApps : [App]
    var body:some View{
        VStack(alignment: .leading){
            Text(title).padding(.horizontal).font(.system(size: 26, weight: .bold))
            ScrollView(.horizontal,showsIndicators: false){
                HStack(spacing: 10){
                    ForEach(0..<3,id: \.self){number in
                        VStack(alignment: .leading,spacing: 10){
                            ForEach(0..<3,id: \.self){num in
                                HStack{
                                    Image(self.mediumApps[(number * 3) + num].image).cornerRadius(8)
                                    VStack(alignment: .leading){
                                        Text(self.mediumApps[(number * 3) + num].tagline)
                                        Text(self.mediumApps[(number * 3) + num].subheading).lineLimit(1)
                                    }
                                    Spacer()
                                    Button(action: {
                                    }){
                                        Image(systemName: "icloud.and.arrow.down")
                                    }.padding(.trailing,15)

                                }
                            }
                        }.frame(width: UIScreen.main.bounds.width * 0.95).padding(.trailing,10)
                    }

                }
            }.padding(.horizontal)
        }


    }
}

struct SmallTableView:View {
    var smallTableApps : [App]
    var body: some View{
        HStack{
            VStack(alignment: .leading,spacing: 10){
                Text("Top Categories").font(.system(size: 25, weight: .bold))
                ForEach(0..<smallTableApps.count,id:\.self){number in
                    VStack(alignment: .leading){
                        HStack(spacing: 10){
                            Image(self.smallTableApps[number].image).resizable().frame(width: UIScreen.main.bounds.width * 0.08,height: UIScreen.main.bounds.width * 0.08).cornerRadius(8)
                            Text(self.smallTableApps[number].name)
                        }
                        if number != 4{
                            Divider()
                        }

                    }

                }
            }.padding(.horizontal)
            Spacer()
        }
    }
}
